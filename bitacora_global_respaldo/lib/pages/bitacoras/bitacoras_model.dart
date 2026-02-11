import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import '/index.dart';
import 'bitacoras_widget.dart' show BitacorasWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BitacorasModel extends FlutterFlowModel<BitacorasWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;
  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, BitacoraRecord>? listViewPagingController;
  Query? listViewPagingQuery;

  @override
  void initState(BuildContext context) {
    sideNav02Model = createModel(context, () => SideNav02Model());
  }

  @override
  void dispose() {
    sideNav02Model.dispose();

    listViewPagingController?.dispose();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, BitacoraRecord> setListViewController(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController ??= _createListViewController(query, parent);
    if (listViewPagingQuery != query) {
      listViewPagingQuery = query;
      listViewPagingController?.refresh();
    }
    return listViewPagingController!;
  }

  PagingController<DocumentSnapshot?, BitacoraRecord> _createListViewController(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, BitacoraRecord>(firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryBitacoraRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 25,
          isStream: false,
        ),
      );
  }
}
