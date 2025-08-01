@AbapCatalog.sqlViewName: 'ZPURREG'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view ZCE_PUR_REG
  as select from I_SupplierInvoiceAPI01        as A
    left outer join   I_SuplrInvcItemPurOrdRefAPI01 as b on  b.SupplierInvoice = A.SupplierInvoice
                                                    and b.FiscalYear      = A.FiscalYear
  //                         inner join I_BusinessPartnerAddress as c on c.BusinessPartner = A.SupplierInvoice
    left outer join   I_PurchaseOrderAPI01          as d on d.PurchaseOrder = b.PurchaseOrder
    left outer join   I_Businesspartnertaxnumber    as e on e.BusinessPartner = d.Supplier
    left outer join  I_Supplier                    as f on f.Supplier = A.InvoicingParty
    //d.Supplier
    inner join   I_PurchaseOrderItemAPI01      as g on g.PurchaseOrder = d.PurchaseOrder
                                                    and g.PurchaseOrderItem = b.PurchaseOrderItem 
    left outer join I_TaxCodeText as h on h.TaxCode = b.TaxCode
                                  and h.TaxCalculationProcedure = '0TXIN'
                                  and h.Language = 'E'  
    inner join I_ProductTypeCodeText as i on i.ProductTypeCode = g.ProductType
                                          and i.Language = 'E'                                                                                 
  //                         inner join I_PurchaseOrderItem as e on e.PurchaseOrder = b.PurchaseOrder



{
  key     A.InvoicingParty,
  key     A.FiscalYear,
  key     A.SupplierInvoiceWthnFiscalYear,
  key     A.SupplierInvoice,
  key     b.SupplierInvoiceItem,
  key     b.PurchaseOrder,
  key     b.PurchaseOrderItem,
  key     d.Supplier,
  key     b.Plant,
  key     A.DocumentDate,
  key     A.PostingDate,
          A.SupplierInvoiceIDByInvcgParty,
          //    c.FullName,
          //    c.CityName
          d.PurchaseOrderType,
          A.DocumentCurrency,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          A.InvoiceGrossAmount,
          b.PurchaseOrderItemMaterial,
          b.PurchaseOrderQuantityUnit,
          @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
          b.QuantityInPurchaseOrderUnit,
          b.SupplierInvoiceItemAmount,
          b.TaxCode,
          b.SuplrInvcDeliveryCostCndnType,
          b.SupplierInvoiceItemText,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
            when b.SuplrInvcDeliveryCostCndnType = 'ZLFV' or  b.SuplrInvcDeliveryCostCndnType = 'ZLF1'
              then b.SupplierInvoiceItemAmount
            else cast(0 as abap.curr(15,2))
            end                                   as locfcharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
           when b.SuplrInvcDeliveryCostCndnType = 'ZFVI' or  b.SuplrInvcDeliveryCostCndnType = 'ZIF1'
             then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
           end                                    as impfcharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZPG1' or  b.SuplrInvcDeliveryCostCndnType = 'ZPQ1'
               or b.SuplrInvcDeliveryCostCndnType = 'ZPV1'
             then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
           end                                    as parkcharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZIIV'
             then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
           end                                    as inscharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZOTC'
             then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
           end                                    as otherexp,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZBCD' or b.SuplrInvcDeliveryCostCndnType = 'ZIOT'
             then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
           end                                    as custdcharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZSWC'
            then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
          end                                     as swscharge,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZCHA' or b.SuplrInvcDeliveryCostCndnType ='ZTCH'
            or b.SuplrInvcDeliveryCostCndnType = 'ZSTD' or b.SuplrInvcDeliveryCostCndnType ='ZSLC'
            or b.SuplrInvcDeliveryCostCndnType = 'ZCFS'
            then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
          end                                     as chacharge,
          b.SuplrInvcItmUnplndDelivCost,
          //     @Semantics.amount.currencyCode: 'DocumentCurrency'
          //      A.ExchangeRate,
          cast( A.ExchangeRate as abap.dec(9,5) ) as ExchangeRate,
          //      b.Plant,
          e.BPTaxNumber,
          f.CityName,
          f.BPSupplierFullName                      as fullname,
          h.TaxCodeName,
          i.Name,
          g.ProductType,
          g.PurchaseOrderItemText,
          sum(b.SupplierInvoiceItemAmount) +
          sum(
          case
          when b.SuplrInvcDeliveryCostCndnType = 'ZLFV' or b.SuplrInvcDeliveryCostCndnType = 'ZLF1'
          or b.SuplrInvcDeliveryCostCndnType = 'ZFVI' or b.SuplrInvcDeliveryCostCndnType = 'ZIF1' or b.SuplrInvcDeliveryCostCndnType = 'ZPG1'
          or  b.SuplrInvcDeliveryCostCndnType = 'ZPQ1' or b.SuplrInvcDeliveryCostCndnType = 'ZPV1' or b.SuplrInvcDeliveryCostCndnType = 'ZIIV'
          or b.SuplrInvcDeliveryCostCndnType = 'ZOTC' or b.SuplrInvcDeliveryCostCndnType = 'ZBCD' or b.SuplrInvcDeliveryCostCndnType = 'ZIOT'
          or b.SuplrInvcDeliveryCostCndnType = 'ZSWC' or b.SuplrInvcDeliveryCostCndnType = 'ZCHA' or b.SuplrInvcDeliveryCostCndnType ='ZTCH'
            or b.SuplrInvcDeliveryCostCndnType = 'ZSTD' or b.SuplrInvcDeliveryCostCndnType ='ZSLC' or b.SuplrInvcDeliveryCostCndnType = 'ZCFS'
          then b.SupplierInvoiceItemAmount
          else cast(0 as abap.curr(15,2))
          end
          )                                       as GrandTotalAmount
          //      @Semantics.quantity.unitOfMeasure : 'PurchaseOrderQuantityUnit'
          //      b.SupplierInvoiceItemAmount   as sum1

}

group by
  A.InvoicingParty,
  A.FiscalYear,
  A.SupplierInvoiceWthnFiscalYear,
  A.SupplierInvoice,
  b.SupplierInvoiceItem,
  b.PurchaseOrder,
  b.Plant,
  b.PurchaseOrderItem,
  d.Supplier,
  A.DocumentDate,
  A.PostingDate,
  A.SupplierInvoiceIDByInvcgParty,
  d.PurchaseOrderType,
  A.DocumentCurrency,
  A.InvoiceGrossAmount,
  b.PurchaseOrderItemMaterial,
  b.PurchaseOrderQuantityUnit,
  b.QuantityInPurchaseOrderUnit,
  b.SupplierInvoiceItemAmount,
  b.TaxCode,
  b.SuplrInvcDeliveryCostCndnType,
  b.SuplrInvcItmUnplndDelivCost,
  b.SupplierInvoiceItemText,
  //     @Semantics.amount.currencyCode: 'DocumentCurrency'
  //      A.ExchangeRate,
  A.ExchangeRate,
  //  b.Plant,
  e.BPTaxNumber,
  f.CityName,
  f.BPSupplierFullName,
  h.TaxCodeName,
  i.Name,
  g.ProductType,
  g.PurchaseOrderItemText
