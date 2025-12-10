using PurchaseOrderManagement as service from '../../srv/service';
annotate service.POHeader with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'po_number',
                Value : po_number,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_coco',
                Value : po_coco,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_org',
                Value : po_org,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_curr_code',
                Value : po_curr_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_doc_date',
                Value : po_doc_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_delivery_date',
                Value : po_delivery_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'total_po_value',
                Value : total_po_value,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_status',
                Value : po_status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_approvalstatus_ApprovalBy',
                Value : po_approvalstatus_ApprovalBy,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_approvalstatus_ApprovedAt',
                Value : po_approvalstatus_ApprovedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_remarks',
                Value : po_remarks,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'po_number',
            Value : po_number,
        },
        {
            $Type : 'UI.DataField',
            Label : 'po_coco',
            Value : po_coco,
        },
        {
            $Type : 'UI.DataField',
            Label : 'po_org',
            Value : po_org,
        },
        {
            $Type : 'UI.DataField',
            Label : 'po_curr_code',
            Value : po_curr_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'po_doc_date',
            Value : po_doc_date,
        },
    ],
    UI.FieldGroup #Items : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : to_po_items.po_item_id,
            },
            {
                $Type : 'UI.DataField',
                Value : to_po_items.po_itm_gst_percent,
            },
        ],
    },
);

annotate service.POItems with @(
    UI.Facets : [
        
    ],
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected',
            Label : 'Item ID',
        },
    ],
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{to_inv_item_inv_itm_id} {po_itm_dicount}',
        Data : {
            $Type : 'Core.Dictionary',
            to_inv_item_inv_itm_id : {
                $Type : 'UI.DataField',
                Value : to_inv_item.inv_itm_id,
            },
            po_itm_dicount : {
                $Type : 'UI.DataField',
                Value : po_itm_dicount,
            },
        },
    },
);

