sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ust.po.masterdata.ustpo',
            componentId: 'POHeaderList',
            contextPath: '/POHeader'
        },
        CustomPageDefinitions
    );
});