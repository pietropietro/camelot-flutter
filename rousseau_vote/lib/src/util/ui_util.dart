import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rousseau_vote/src/l10n/rousseau_localizations.dart';
import 'package:rousseau_vote/src/models/arguments/blog_instant_article_arguments.dart';
import 'package:rousseau_vote/src/models/browser_arguments.dart';
import 'package:rousseau_vote/src/screens/blog_instant_article_screen.dart';
import 'package:rousseau_vote/src/screens/in_app_browser.dart';

void showRousseauSnackbar(BuildContext context,
    GlobalKey<ScaffoldState> scaffoldState, String errorMessage) {
  final SnackBar snackBar = SnackBar(
    content: Text(RousseauLocalizations.getText(context, errorMessage)),
    duration: const Duration(seconds: 5),
  );

  scaffoldState.currentState.showSnackBar(snackBar);
}

String formatDate(BuildContext context, DateTime dateTime) {
  return DateFormat.yMMMd(RousseauLocalizations.of(context).currentLanguage)
      .addPattern(" '-' ")
      .add_jm()
      .format(dateTime);
}

void openUrlInternal(BuildContext context, String url) {
  if (isBlogArticle(url)) {
    final String slug = getArticleSlug(url);
    openBlogInstantArticle(context, slug);
  } else {
    openLink(context, BrowserArguments(url: url));
  }
}

Function openUrlInternalAction(BuildContext context, String url) {
  return () {
    openUrlInternal(context, url);
  };
}

Function openBlogInstantArticleAction(BuildContext context, String slug) {
  return () {
    openBlogInstantArticle(context, slug);
  };
}

void openBlogInstantArticle(BuildContext context, String slug) {
  final BlogInstantArticleArguments arguments = getBlogInstantArticleArguments(slug);
  Navigator.of(context)
      .pushNamed(BlogInstantArticleScreen.ROUTE_NAME, arguments: arguments);
}

void openLink(BuildContext context, BrowserArguments arguments) {
  Navigator.of(context)
      .pushNamed(InAppBrowser.ROUTE_NAME, arguments: arguments);
}

Function openLinkAction(BuildContext context, BrowserArguments arguments) {
  return () {
    openLink(context, arguments);
  };
}

void openRoute(BuildContext context, String route, {Object arguments, bool replace = false}) {
  if (replace) {
    Navigator.of(context).pushReplacementNamed(route, arguments: arguments);
  } else {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }
}

Function openRouteAction(BuildContext context, String route, {Object arguments, bool replace = false}) {
  return () {
    openRoute(context, route, arguments: arguments, replace: replace);
  };
}

BlogInstantArticleArguments getBlogInstantArticleArguments(String slug) {
  return BlogInstantArticleArguments(slug);
}

String getArticleSlug(String url) {
  if (!isBlogArticle(url)) {
    return null;
  }
  return url.substring(url.lastIndexOf('/') + 1);
}

bool isBlogArticle(String url) {
  return url.startsWith('https://www.ilblogdellestelle.it/');
}
