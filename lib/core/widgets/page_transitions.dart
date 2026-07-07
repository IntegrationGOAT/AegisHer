// Page transitions — shared-axis-style route transitions tuned for the
// futuristic app. Wraps the standard MaterialPageRoute so we can swap in our
// own PageTransitionsBuilder through PageTransitionsTheme.
//
// The transition is a hybrid of FadeThrough + SharedAxis horizontal that we
// implement manually so we can keep the curves consistent with AegisMotion.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

/// A horizontal shared-axis transition: incoming slides in from the right
/// with a fade and a tiny scale; outgoing mirrors in reverse.
class SharedAxisPageTransitionsBuilder extends PageTransitionsBuilder {
  const SharedAxisPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isEntering = animation.status == AnimationStatus.forward ||
        animation.status == AnimationStatus.completed;
    final curved = CurvedAnimation(parent: animation, curve: AegisMotion.emphasized);
    final curvedSecondary = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AegisMotion.emphasized,
    );

    final slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(curved);
    final scale = Tween<double>(begin: 0.98, end: 1).animate(curved);
    final fade = Tween<double>(begin: 0, end: 1).animate(curved);

    final outSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.06, 0),
    ).animate(curvedSecondary);
    final outFade = Tween<double>(begin: 1, end: 0).animate(curvedSecondary);

    return FadeTransition(
      opacity: isEntering ? fade : outFade,
      child: SlideTransition(
        position: isEntering ? slide : outSlide,
        child: ScaleTransition(
          scale: isEntering ? scale : const AlwaysStoppedAnimation<double>(1),
          child: child,
        ),
      ),
    );
  }
}

/// Fade-through transition for modal/sheet-like screens.
class FadeThroughPageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeThroughPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeIn = CurvedAnimation(parent: animation, curve: AegisMotion.standard);
    final scaleIn = Tween<double>(begin: 0.96, end: 1).animate(fadeIn);
    final fadeOut = CurvedAnimation(parent: secondaryAnimation, curve: AegisMotion.standard);
    return FadeTransition(
      opacity: fadeIn,
      child: FadeTransition(
        opacity: ReverseAnimation(fadeOut),
        child: ScaleTransition(scale: scaleIn, child: child),
      ),
    );
  }
}

/// Helpers to construct PageRoute<T> instances with our transition builder.
class AegisPageRoute<T> extends PageRoute<T> {
  AegisPageRoute({
    required this.builder,
    this.transition = AegisPageTransition.sharedAxis,
    super.settings,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  });

  final WidgetBuilder builder;
  final AegisPageTransition transition;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => AegisMotion.pageIn;

  @override
  Duration get reverseTransitionDuration => AegisMotion.pageOut;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final builder = switch (transition) {
      AegisPageTransition.sharedAxis => const SharedAxisPageTransitionsBuilder(),
      AegisPageTransition.fadeThrough => const FadeThroughPageTransitionsBuilder(),
      AegisPageTransition.material => const ZoomPageTransitionsBuilder(),
      AegisPageTransition.cupertino => const CupertinoPageTransitionsBuilder(),
    };
    return builder.buildTransitions(this, context, animation, secondaryAnimation, child);
  }
}

enum AegisPageTransition { sharedAxis, fadeThrough, material, cupertino }
