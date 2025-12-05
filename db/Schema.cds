namespace po.ust;

using {
    managed,
    cuid,
    Currency
} from '@sap/cds/common';


define aspect primary : managed {};
define aspect secondary : cuid {};
//--------------------------------------------------------------------------------------------------------
// TYPE DEFINATIONS STARTS FROM HERE
//--------------------------------------------------------------------------------------------------------

define type address {
    vm_street  : String(50);
    vm_city    : String(20);
    vm_state   : String(20);
    vm_country : String(20) default 'India';
    vm_postal  : String(6);
};

define type email            : String(50);
define type phone            : String(10);

define type payment_terms    : String enum {
    LOW = '30 Days';
    HIGH = '45 Days'
};

// define type material_type {
//     rawmaterial : String(20);
//     service : String(5);
//     others : String(6);
// }

define type material_type    : String enum {
    RawMaterial;
    Service;
    Others
};

define type UoM {
    unit : String(5) default 'KG';
};

define type GST_percent {
    percent : Decimal(2, 2);
};

define type POstatus         : String enum {
    Draft;
    Submitted;
    Approved;
    Rejected;
    Closed;
    Cancelled
}

define type ApprovalStatus {
    ApprovalBy : String(20);
    ApprovedAt : DateTime;
};

define type Remarks          : String(255);

define type Desctiption      : String(50);

define type Discount_percent : Decimal(2, 2);

define type PO_ITM_status    : String enum {
    Open;
    PartiallyReceived;
    FullyReceived;
    Cancelled
}

define type quantity         : Integer default 0;

// define type currency {
//     curr_key : String(3) default 'USD';
// }

define type InvoiceManaged {
    postedBy : String(30);
    postedAt : DateTime;
    verifiedBy : String(30);
    verifiedAt : DateTime
}

define type audit_aspect : managed {
    auditedBy : String(10);
    auditedAt : DateTime;
    verifiedBy : String(10);
    verifiedAt : DateTime;
    ApprovalBy : String(10);
    ApprovedAt : DateTime
}



// --------------------------------------------------------------------------------------------------------
// ENTITY DEFINATIONS STARTS FROM HERE
// --------------------------------------------------------------------------------------------------------

// VENDOR MASTER
define entity VendorMaster : primary {
    key vm_id            : UUID not null;
    vm_code          : String(10) not null;
    vm_firstname     : String(20);
    vm_lastname      : String(20);
    vm_name          : String = vm_firstname || ' ' || vm_lastname;
    vm_address       : address;
    vm_gstno         : String(15) not null;
    vm_contactperson : String(20);
    vm_phone         : phone;
    vm_email         : email;
    // vm_payment_terms : String(6);
    vm_payment_terms : payment_terms;
    vm_is_active     : String(1) not null default 'Y';
    to_po_header : Composition of many POHeader on to_po_header.po_vendor_id = vm_id;
    to_inv_header : Composition of many InvoiceHeader on to_inv_header.inv_vender_id = vm_id;
};

// MATERIAL MASTER
define entity MaterialMaster : primary {
    key mm_id        : UUID not null; 
    mm_code      : String(20) not null;
    mm_desc      : Desctiption;
    mm_type      : material_type;
    mm_uom       : UoM;
    mm_stdprice  : Integer; // Can be decimal
    mm_gst       : GST_percent;
    mm_is_active : String(1) not null default 'Y';
    to_po_items : Composition of many POItems on to_po_items.po_itm_material_id = mm_id;
};

// PURCHASE ORDER HEADER
define entity POHeader : primary {
    key po_id             : UUID not null;
    po_number         : Integer not null;
    // vendor : for foreign key relations for future
    po_vendor_id : VendorMaster:vm_id;
    po_coco           : String(5) not null;
    po_org            : String(5) not null;
    // po_curr : currency;
    po_curr           : Currency;
    po_doc_date       : Date;
    po_delivery_date  : Date;
    po_payment_terms  : VendorMaster:vm_payment_terms;
    total_po_value    : Decimal(8, 2);
    po_status         : POstatus;
    po_approvalstatus : ApprovalStatus;
    po_remarks        : Remarks;
    to_po_items : Composition of many POItems on to_po_items.po_itm_header_id = po_id;  
    to_inv_header : Composition of one InvoiceHeader on to_inv_header.inv_po_header_id = po_id;
    to_gr_header : Composition of many GRHeader on to_gr_header.gr_po_header_id = po_id;

    to_vendor : Association to one VendorMaster on to_vendor.vm_id = po_vendor_id;
    to_logs : Association to many logs on to_logs.log_po_header_id = po_id;
};

// PURCHASE ORDER ITEMS
define entity POItems : primary {
    key po_item_id            : UUID not null;
    // PO_ID : for foreign key relations to POHeader;
    po_itm_header_id : POHeader:po_id;
    po_line_itm_no        : String(15);
    // material : for foreign key relations to MaterialMaster;
    po_itm_material_id : MaterialMaster:mm_id;
    po_itm_desc           : Desctiption;
    po_itm_quantiy        : Integer;
    po_uom                : UoM;
    po_net_price          : Decimal(8, 2);

    po_itm_dicount        : Discount_percent;
    // po_itm_discount : String(4) = String(po_itm_dicount_deci) || '%';
    po_itm_gst            : GST_percent;
    po_line_itm_net_value : Decimal(8, 2);
    po_itm_received_qty   : quantity;
    po_itm_open_qty       : quantity;
    po_itm_status         : PO_ITM_status;
    to_gr_item : Composition of GRItems on to_gr_item.gr_itm_poitem_id = po_item_id;
    to_inv_item : Composition of InvoiceItems on to_inv_item.inv_po_itm_id = po_item_id;

    to_materialmaster : Association to one MaterialMaster on to_materialmaster.mm_id = po_itm_material_id;
    to_po_header : Association to one POHeader on to_po_header.po_id = po_itm_header_id;

};


// GOODS RECEIPT HEADER 
define entity GRHeader : primary {
    key gr_id : UUID not null;
    gr_number             : Integer;
    // PO Refereence : for foreign key relations to POHeader;
    gr_po_header_id : POHeader:po_id;
    gr_date               : Date;
    gr_store_loc : address;
    gr_status             : String enum {
        Draft;
        Posted
    };
    to_gr_item : Composition of many GRItems on to_gr_item.gr_itm_header_id = gr_id;
    to_po_header : Association to one POHeader on to_po_header.po_id = gr_po_header_id;
    // to_inv_header : Composition of InvoiceHeader on to_inv_header.inv_gr_header_id = gr_id;   //dought
};


// GOODS RECEIPT ITEMS
define entity GRItems : primary {
    key gr_item_id : UUID not null;
    // gr_id: for Foreign key relation to GRHeader
    gr_itm_header_id : GRHeader:gr_id;
    // po_item_id : for Foreign key relation to POItems
    gr_itm_poitem_id : POItems:po_item_id;
    gr_itm_received_qty : quantity;
    gr_itm_uom          : UoM;
    gr_itm_batch_no     : Integer;
    gr_remarks          : Remarks;

    to_po_items : Association to one POItems on to_po_items.po_item_id = gr_itm_poitem_id;
    to_gr_header : Association to one GRHeader on to_gr_header.gr_id = gr_itm_header_id;
};


// INVOICE HEADER
define entity InvoiceHeader : primary {
    key inv_id               : UUID not null;
        inv_no               : Integer;
        // vendor : for foreign key relations to Vendor
        inv_vender_id : VendorMaster:vm_id;
        // PO_Reference : for foreign key relations to POHeader
        inv_po_header_id : POHeader:po_id;
        // GR_Reference : for foreign key relations to GRHeader
        inv_gr_header_id : GRHeader:gr_id;
        inv_date             : Date;
        inv_post_date        : Date;
        inv_currency         : Currency;
        inv_total_before_tax : Decimal(8, 2);
        inv_total_amount     : Decimal(8, 2);
        inv_status           : String enum {
            Draft;
            Verified;
            Posted;
            Rejected;
            Cancelled
        };
        inv_verified_posted_managed : InvoiceManaged;
        inv_rejection_remarks : Remarks;
        to_inv_items : Composition of many InvoiceItems on to_inv_items.inv_itm_header_id = inv_id;

        to_vendor : Association to one VendorMaster on to_vendor.vm_id = inv_vender_id;
        to_po_header : Association to one POHeader on to_po_header.po_id = inv_po_header_id;

};


// INVOICE ITEMS
define entity InvoiceItems : primary {
    key inv_itm_id : UUID not null;
    // inv_id : for foreign key realtion with Invheader
    inv_itm_header_id : InvoiceHeader:inv_id;
    // po item reference for foreign key relation with poitem
    inv_po_itm_id : POItems:po_item_id;
    // gr item reference for foreign key realtion with GRItems
    inv_itm_qty : quantity;
    inv_uom : UoM;
    inv_net_price : Decimal(8,2);
    inv_discount : Discount_percent;
    inv_gst : GST_percent;
    inv_line_itm_net_amount : Integer = ((inv_itm_qty * inv_net_price) - (inv_net_price * inv_discount) / 100);
    // inv_line_itm_net_amount : Decimal(8, 2);
    inv_line_itm_tax : Decimal(8,2);
    inv_line_itm_total : Decimal(8,2);

    to_po_items : Association to one POItems on to_po_items.po_item_id = inv_po_itm_id;
};

// ERORR AND AUDIT LOGS
define entity logs : primary {
    key error_id : UUID not null;
    // PO Header : for foreign key reference to POHeader\
    log_po_header_id : POHeader:po_id;
    error_status : String(3);
    audit_status : String(10);
    audit_log : audit_aspect;

    to_po_header : Association to one POHeader on to_po_header.po_id = log_po_header_id;
}
