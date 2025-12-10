sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'ust.po.masterdata.ustpo',
            componentId: 'POHeaderObjectPage',
            contextPath: '/POHeader'
        },
        CustomPageDefinitions
    );
});