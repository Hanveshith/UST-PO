using {po.ust as db} from '../db/Schema';

define service MasterData @(path : 'masterdata') {
    entity VendorMaster as projection on db.VendorMaster;
    entity MaterialMaster as projection on db.MaterialMaster;
}