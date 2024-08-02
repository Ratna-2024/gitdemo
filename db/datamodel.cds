namespace ratna.db;
using { cuid, managed, temporal, Currency } from '@sap/cds/common';
using { ratna.common } from './common';



type Guid : String(32);

context master {
    entity businesspartner {
        key NODE_KEY: Guid;
        BP_ROLE: String(2);
        EMAIL_ADDRESS: String(64);
        PHONE_NUMBER: String(14);
        FAX_NUMBER: String(14);
        WEB_NUMBER: String(64);
        ADDRESS_GUID: Association to address;
        BP_ID: String(16);
        COMPANY_NAME: String(80);
    }

annotate businesspartner with {
    NODE_KEY @title : '{i18n>bp_key}';
    BP_ROLE @title: '{i18n>bp_role}';
    COMPANY_NAME @title : '{i18n>comapny_name}';
    BP_ID @title : '{i18n>bp_id}';
    EMAIL_ADDRESS @title : '{i18n>email_addr}';

}; 


     entity address {
        key NODE_KEY: Guid;
        CITY: String(64);
        POSTAL_CODE: String(60);
        STATE: String(120);
        BUILDING: String(120);
        COUNTRY: String(4);
        ADDRESS_TYPE: Integer;
        VAL_START_DATE: Date;
        VAL_END_DATE: Date;
        LATITUDE: Decimal;
        LONGITUDE: Decimal;
        businesspartner: Association to one businesspartner on businesspartner.ADDRESS_GUID = $self;
     }

    //  entity prodtext {   
    //     key NODE_KEY: Guid;
    //     PARENT_KEY: Guid;
    //     language: String(2);
    //     TEXT: String(256);
    //  }

     entity product {
        key NODE_KEY: Guid;
        PRODUCT_ID: String(28);
        TYPE_CODE: String(2);
        CATEGORY: String(32);
     //   DESC_GUID: Association to prodtext;
        DESCRIPTION: localized String(255);
        SUPPLIER_GUID: Association to master.businesspartner;
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Decimal;
        WEIGHT_UNIT: String(2);
        CURRENCY_CODE: String(4);
        PRICE: Decimal(15,2);
        WIDTH: Decimal(5,2);
        DEPTH: Decimal(5,2);
        HEIGHT: Decimal(5,2);
        DIM_UINT: String(2);

     }

    entity employees : cuid, temporal {
        nameFirst: String(40);
        nameMiddle: String(40);
        nameLast: String(40);
        nameInitials: String(40);
        sex: common.Gender;
        language: String(1);
        phonenumber: common.phonenumber; 
        email: common.Email; 
        loginName: String(12);
        currency_code: Currency; 
        salaryAmount: common.AmountT; 
        accountNumber: String(16); 
        backId: String(8); 
        bankName: String(64);
    }

}


context transaction {
    
    entity purchaseorder: common.Amount {
        key NODE_KEY:Guid;
        PO_ID: String(24);
        PARTNER_GUID: Association to master.businesspartner;
        LIFECYCLE_STATUS: String(1);
        OVERALL_STATUS: String(1);
        Items: association to many poitems on Items.PARENT_KEY = $self
    }

    entity poitems: common.Amount {
        key NODE_KEY: Guid;
        PARENT_KEY: Association to purchaseorder;
        PO_ITEM_POS: Integer;
        PRODUCT_GUID: association to master.product;
    }
}


