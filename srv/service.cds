using {po.ust as db} from '../db/Schema';

define service MasterData @(path : 'masterdata') {
    entity VendorMaster as projection on db.VendorMaster;
    entity MaterialMaster as projection on db.MaterialMaster;
}

define service PurchaseOrderManagement @(path : 'POManagement') {
    entity POHeader as projection on db.POHeader;
    entity POItems as projection on db.POItems;
}

define service GoodsReceiptManagement @(path : 'GRManagement') {
    entity GRHeader as projection on db.GRHeader;
    entity GRItems as projection on db.GRItems;
}

define service InvoiceManagement @(path : 'InvManagement') {
    entity InvoiceHeader as projection on db.InvoiceHeader;
    entity InvoiceItems as projection on db.InvoiceItems;
}