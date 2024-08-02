using { ratna.db.master, ratna.db.transaction } from '../db/datamodel';


service CatalogService@(path: '/CatalogService') {

   entity EmployeeSet as projection on master.employees; 
   entity addressSet as projection on master.address; 
   entity productSet as projection on master.product; 
 //  entity productTextsSet as projection on master.prodtext; 
   entity BPSet as projection on master.businesspartner; 

  entity Pos @(
    title: '{i18n>poHeader}' 
  ) as projection on transaction.purchaseorder{
    *,
    Items: redirected to transaction.poitems
  }
  entity POItems @( title : '{i18n>poItems}' )
  as projection on transaction.poitems{
    *,
    PARENT_KEY: redirected to Pos,
    PRODUCT_GUID: redirected to productSet



  }
  
    
  
}
