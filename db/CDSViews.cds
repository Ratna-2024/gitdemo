namespace ratna.db;

using
{
    ratna.db.master,
    ratna.db.transaction
}
from './datamodel';

entity magic
{
    key ID : Integer;
    Name : String(50);
    Salry : Decimal(10,2);
    currency : String(4);
}

context CDSViews
{
    annotate ProductValueHelp
    {
        ProductId
            @EndUserTExt.lable :
            [
                { language : 'EN', text : 'Product ID' },
                { language : 'DE', text : 'Produkt ID' }
            ];
        Description
            @EndUserTExt.lable :
            [
                { language : 'EN', text : 'Product Description' },
                { language : 'DE', text : 'Produktbeschreibung' }
            ];
    }

    annotate ProductView
    {
        BPID
            @title : '{i18n>bp_id}';
        CompanyName
            @title : '{i18n>comapny_name}';
    }

    entity POWorklist
    {
        key purchaseorderId : String(24);
        PartnerId : String(16)
            @title : '{i18n>bp_id}';
        CompanyName : String(80)
            @title : '{i18n>comapny_name}';
        POGrossAmount : ratna.common.AmountT;
        POCurrencyCode : String(4);
        POStatus : String(1);
        key ItemPosition : Integer;
        ProductId : String(28);
        ProcudtName : localized String(255);
        City : String(64);
        Country : String(4);
        GrossAmount : ratna.common.AmountT;
        NetAmount : ratna.common.AmountT;
        TaxAmount : ratna.common.AmountT;
        CurrencyCode : String(4);
    }

    entity ProductValueHelp as
        select from master.product
        {
                @EndUserTExt.lable : [
            {
                language : 'EN',
                text : 'Product ID'
            }
            ,
            {
                language : 'DE',
                text : 'Produkt ID'
            }
            ] PRODUCT_ID as ![ProductId],
                @EndUserTExt.lable : [
            {
                language : 'EN',
                text : 'Product Description'
            }
            ,
            {
                language : 'DE',
                text : 'Produktbeschreibung'
            }
            ] DESCRIPTION as ![Description]
        };

    entity ItemView
    {
        Partner : db.Guid
            @title : '{i18n>bp_key}';
        ProductId : db.Guid;
        CurrencyCode : String(4);
        GrossAmount : ratna.common.AmountT;
        NetAmount : ratna.common.AmountT;
        TaxAmount : ratna.common.AmountT;
        POStatus : String(1);
    }

    entity ProductViewSub as
        select from master.product as prod
        {
            PRODUCT_ID as ![ProductId],
            texts.DESCRIPTION as ![Description],
            (select from transaction.poitems as a
                {
                    SUM(a.GROSS_AMOUNT) as SUM
                }
                where a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY) as PO_SUM : Decimal(10,
                2)
        };

    entity ProductView as
        select from master.product
        mixin
        {
            PO_ORDERS : Association [*] to ItemView on PO_ORDERS.ProductId =$projection.ProductId
        }
        into
        {
            NODE_KEY as ![ProductId],
            DESCRIPTION,
            CATEGORY as ![Category],
            PRICE as ![Price],
            TYPE_CODE as ![TypeCode],
            SUPPLIER_GUID.BP_ID as ![BPID],
            SUPPLIER_GUID.COMPANY_NAME as ![CompanyName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY as ![City],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
            PO_ORDERS
        };

    entity CProductValuesView as
        select from ProductView
        {
            ProductId,
            Country,
            PO_ORDERS.CurrencyCode as ![CurrencyCode],
            sum(PO_ORDERS.GrossAmount) as ![POGrossAmount] : Decimal(10,2)
        }
        group by ProductId, Country, PO_ORDERS.CurrencyCode;
}
