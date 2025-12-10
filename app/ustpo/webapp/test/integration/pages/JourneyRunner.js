sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ust/po/masterdata/ustpo/test/integration/pages/POHeaderList",
	"ust/po/masterdata/ustpo/test/integration/pages/POHeaderObjectPage",
	"ust/po/masterdata/ustpo/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, POHeaderList, POHeaderObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ust/po/masterdata/ustpo') + '/test/flp.html#app-preview',
        pages: {
			onThePOHeaderList: POHeaderList,
			onThePOHeaderObjectPage: POHeaderObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

