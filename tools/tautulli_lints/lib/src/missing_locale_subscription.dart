import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class MissingLocaleSubscription extends AnalysisRule {
  static const LintCode code = LintCode(
    'missing_locale_subscription',
    "build() calls .tr() {0}without 'context.locale;' — translated text won't update on a runtime language change.",
    correctionMessage: "Add 'context.locale;' at the top of build().",
  );

  MissingLocaleSubscription()
      : super(
          name: 'missing_locale_subscription',
          description: "build() methods that call .tr() must read context.locale to subscribe to locale changes.",
        );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    registry.addMethodDeclaration(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (!_isBuildMethod(node)) return;

    final body = node.body;
    if (body is! BlockFunctionBody) return;

    final callSite = _findTrCallSite(node, body);
    if (callSite == null) return;

    final localeChecker = _HasContextLocale();
    body.accept(localeChecker);
    if (localeChecker.found) return;

    rule.reportAtNode(
      node,
      arguments: [callSite.isEmpty ? '' : "via '$callSite()' "],
    );
  }

  /// Returns null if build makes no .tr() call.
  /// Returns '' if .tr() is called directly inside the build body.
  /// Returns the helper method name if .tr() is called inside a private
  /// helper method invoked from build.
  String? _findTrCallSite(MethodDeclaration buildNode, BlockFunctionBody body) {
    final directChecker = _HasTrCall();
    body.accept(directChecker);
    if (directChecker.found) return '';

    final helperNames = _PrivateHelperCallCollector();
    body.accept(helperNames);
    if (helperNames.names.isEmpty) return null;

    final parent = buildNode.parent;
    if (parent is! ClassBody) return null;

    for (final member in parent.members) {
      if (member is MethodDeclaration && helperNames.names.contains(member.name.lexeme)) {
        final helperTrChecker = _HasTrCall();
        member.body.accept(helperTrChecker);
        if (helperTrChecker.found) return member.name.lexeme;
      }
    }

    return null;
  }

  bool _isBuildMethod(MethodDeclaration node) {
    if (node.name.lexeme != 'build') return false;
    final params = node.parameters?.parameters;
    if (params == null || params.isEmpty) return false;
    return params.any((p) => p.name?.lexeme == 'context');
  }
}

/// Recursively searches an AST subtree for any `.tr()` call.
class _HasTrCall extends RecursiveAstVisitor<void> {
  bool found = false;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name == 'tr') {
      found = true;
      return;
    }
    super.visitMethodInvocation(node);
  }
}

/// Collects names of unqualified private method calls (e.g. `_buildContent()`)
/// found anywhere in the visited subtree.
class _PrivateHelperCallCollector extends RecursiveAstVisitor<void> {
  final Set<String> names = {};

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.target == null && node.methodName.name.startsWith('_')) {
      names.add(node.methodName.name);
    }
    super.visitMethodInvocation(node);
  }
}

/// Recursively searches an AST subtree for a `context.locale` access.
class _HasContextLocale extends RecursiveAstVisitor<void> {
  bool found = false;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.name == 'context' && node.identifier.name == 'locale') {
      found = true;
      return;
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.target is SimpleIdentifier &&
        (node.target as SimpleIdentifier).name == 'context' &&
        node.propertyName.name == 'locale') {
      found = true;
      return;
    }
    super.visitPropertyAccess(node);
  }
}
