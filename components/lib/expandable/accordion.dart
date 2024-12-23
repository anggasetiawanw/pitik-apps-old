// ignore_for_file: slash_for_doc_comments, no_logic_in_create_state, must_be_immutable

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class Accordion extends StatefulWidget {
  /// An accordion is used to show (and hide) content. Use [showAccordion] to hide & show the accordion content.
  Accordion(
      {Key? key,
      this.title,
      this.content,
      this.titleChild,
      this.contentChild,
      this.collapsedTitleBackgroundColor = GFColors.WHITE,
      this.expandedTitleBackgroundColor = const Color(0xFFE0E0E0),
      this.collapsedIcon = const Icon(Icons.keyboard_arrow_down),
      this.expandedIcon = const Icon(Icons.keyboard_arrow_up),
      this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
      this.titlePadding = const EdgeInsets.all(10),
      this.contentBackgroundColor,
      this.contentPadding = const EdgeInsets.all(10),
      this.titleBorder = const Border(),
      this.contentBorder = const Border(),
      this.margin,
      this.showAccordion = false,
      this.onToggleCollapsed,
      this.titleBorderRadius = const BorderRadius.all(Radius.circular(0)),
      this.contentBorderRadius = const BorderRadius.all(Radius.circular(0))})
      : super(key: key);

  /// controls if the accordion should be collapsed or not making it possible to be controlled from outside
  final bool showAccordion;

  /// child of  type [Widget]is alternative to title key. title will get priority over titleChild
  final Widget? titleChild;

  /// content of type[String] which shows the messages after the [Accordion] is expanded
  final String? content;

  /// contentChild of  type [Widget]is alternative to content key. content will get priority over contentChild
  final Widget? contentChild;

  /// type of [Color] or [GFColors] which is used to change the background color of the [Accordion] title when it is collapsed
  final Color collapsedTitleBackgroundColor;

  /// type of [Color] or [GFColors] which is used to change the background color of the [Accordion] title when it is expanded
  final Color expandedTitleBackgroundColor;

  /// collapsedIcon of type [Widget] which is used to show when the [Accordion] is collapsed
  final Widget collapsedIcon;

  /// expandedIcon of type[Widget] which is used when the [Accordion] is expanded
  final Widget expandedIcon;

  /// text of type [String] is alternative to child. text will get priority over titleChild
  final String? title;

  /// textStyle of type [textStyle] will be applicable to text only and not for the child
  final TextStyle textStyle;

  /// titlePadding of type [EdgeInsets] which is used to set the padding of the [Accordion] title
  final EdgeInsets titlePadding;

  /// descriptionPadding of type [EdgeInsets] which is used to set the padding of the [Accordion] description
  final EdgeInsets contentPadding;

  /// type of [Color] or [GFColors] which is used to change the background color of the [Accordion] description
  final Color? contentBackgroundColor;

  /// margin of type [EdgeInsets] which is used to set the margin of the [Accordion]
  final EdgeInsets? margin;

  /// titleBorderColor of type  [Color] or [Colors] which is used to change the border color of title
  final Border titleBorder;

  /// contentBorderColor of type  [Color] or [Colors] which is used to change the border color of content
  final Border contentBorder;

  /// titleBorderRadius of type  [Radius]  which is used to change the border radius of title
  final BorderRadius titleBorderRadius;

  /// contentBorderRadius of type  [Radius]  which is used to change the border radius of content
  final BorderRadius contentBorderRadius;

  /// function called when the content body collapsed
  // ignore: avoid_positional_boolean_parameters
  final Function(bool)? onToggleCollapsed;

  AccordionState state = AccordionState();

  @override
  AccordionState createState() => state;
}

class AccordionState extends State<Accordion> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool showAccordion;

  @override
  void initState() {
    showAccordion = widget.showAccordion;
    if (showAccordion) {
      showAccordion = false;
      Future.delayed(const Duration(milliseconds: 200), () => toggleCollapsed());
    }

    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    offset = Tween(begin: const Offset(0, -0.06), end: Offset.zero).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: widget.margin ?? const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        InkWell(
            onTap: toggleCollapsed,
            borderRadius: widget.titleBorderRadius,
            child: Container(
                decoration: BoxDecoration(borderRadius: widget.titleBorderRadius, border: widget.titleBorder, color: showAccordion ? widget.expandedTitleBackgroundColor : widget.collapsedTitleBackgroundColor),
                padding: widget.titlePadding,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Expanded(child: widget.title != null ? Text(widget.title!, style: widget.textStyle) : (widget.titleChild ?? Container())), showAccordion ? widget.expandedIcon : widget.collapsedIcon]))),
        showAccordion
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: widget.contentBorderRadius,
                  border: widget.contentBorder,
                  color: widget.contentBackgroundColor ?? Colors.white70,
                ),
                width: MediaQuery.of(context).size.width,
                padding: widget.contentPadding,
                child: SlideTransition(position: offset, child: widget.content != null ? Text(widget.content!) : (widget.contentChild ?? Container())))
            : Container()
      ]));

  void toggleCollapsed() {
    setState(() {
      switch (controller.status) {
        case AnimationStatus.completed:
          controller.forward(from: 0);
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
      }

      showAccordion = !showAccordion;
      if (widget.onToggleCollapsed != null) {
        widget.onToggleCollapsed!(showAccordion);
      }
    });
  }
}
