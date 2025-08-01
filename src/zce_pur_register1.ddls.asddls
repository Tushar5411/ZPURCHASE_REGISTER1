@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_PURCHASE_REGISTER2'
    }
}

@UI.headerInfo: { typeName: 'Purchase Register' ,
                  typeNamePlural: 'Purchase Register' }

@EndUserText.label: 'purchase register'

define custom entity zce_pur_register1
{
      @UI.facet        : [{ id : 'POSTINGDATE',
              purpose  : #STANDARD,
              type     : #IDENTIFICATION_REFERENCE,
              label    : 'Purchase Register',
              position : 10 }
              ]

      @UI.selectionField         : [{position: 10 }]
      @UI.lineItem     : [{label: 'Posting Date', position: 10 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Posting Date', position: 10 }]
     key POSTINGDATE      : datum;
      //  @UI.selectionField         : [{position: 20 }]
      @UI.lineItem     : [{label: 'Document Date', position: 20 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Document Date',position: 20 }]
      DOCUMENTDATE     : datum;
      //@UI.selectionField         : [{position: 30 }]
      @UI.lineItem     : [{label: 'Purch Inv No', position: 30 ,importance: #HIGH }]
      @UI.identification         : [{ position: 30 }]
      purinvno         : vbeln;
      // @UI.selectionField         : [{position: 40 }]
      @UI.lineItem     : [{label: 'Supplier Inv No', position: 40 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Supplier Inv No' , position: 40 }]
      supinvno         : vbeln;
      // @UI.selectionField         : [{position: 50 }]
      @UI.lineItem     : [{label: 'Supplier Name', position: 50 ,importance: #HIGH }]
      @UI.identification         : [{ position: 50 }]
      supname          : abap.char(40);
      @UI.lineItem     : [{label: 'GST', position: 60 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Supplier Name' , position: 60 }]
      gst              : stcd3;
      @UI.lineItem     : [{label: 'Import/Domestic', position: 70 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Import/Domestic', position: 70 }]
      imprt            : abap.char(40);
      @UI.lineItem     : [{label: 'Type', position: 80 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Type', position: 80 }]
      type             : abap.char(40);
      @UI.lineItem     : [{label: 'Currency', position: 90 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Currency', position: 90 }]
      DOCUMENTCURRENCY : waers;
      @UI.lineItem     : [{label: 'Total Amount', position: 100 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Total Amount', position: 100 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      totamt           : dmbtr;


      @UI.lineItem     : [{label: 'Material Code', position: 115 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Invoice Item Text', position: 115 }]      
      Invtext           : posnr;
     
      @UI.lineItem     : [{label: 'Item No', position: 110 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Item No',position: 110 }]      
      itemno           : posnr;
      
      @UI.lineItem     : [{label: 'Material Code', position: 120 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Material Code', position: 120 }]
      
      matnr            : matnr;
      @UI.lineItem     : [{label: 'Material Description', position: 125 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Material Description', position: 125 }]
      maktx            : maktx;
      @UI.lineItem     : [{label: 'UOM', position: 130 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'UOM', position: 130 }]
      uom              : meins;
      @UI.lineItem     : [{label: 'Quantity', position: 140 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Quantity',position: 140 }]
      @Semantics.quantity.unitOfMeasure : 'uom'
      fkimg            : menge_d;
      @UI.lineItem     : [{label: 'Rate', position: 150 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Rate', position: 150 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      RATE             : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Net Amount', position: 160 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Net Amount',position: 160 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      netamt           : dmbtr;
      @UI.lineItem     : [{label: 'Tax Code', position: 170 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Tax Code', position: 170 }]
      taxcode          : abap.char(10);
      @UI.lineItem     : [{label: 'Tax Percentage', position: 180 ,importance: #HIGH }]
      @UI.identification         : [{ label: 'Tax Percentage', position: 180 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      taxper           : abap.curr(10,2);
      @UI.lineItem     : [{label: 'CGST Value', position: 190 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'CGST Value', position: 190 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      cgstvalue        : dmbtr;
      @UI.lineItem     : [{label: 'SGST Value', position: 200 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'SGST Value', position: 200 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      sgstvalue        : dmbtr;
      @UI.lineItem     : [{label: 'IGST Value', position: 210 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'IGST Value', position: 210 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      igstvalue        : dmbtr;
      @UI.lineItem     : [{label: 'Freight', position: 220 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Freight', position: 220 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      freight          : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Packing Charges', position: 230 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Packing Charges', position: 230 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      pack             : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Insurence Charges', position: 240 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Insurence Charges', position: 240 }]
      @Semantics.amount.currencyCode : 'DOCUMENTcurrency'
      insurence        : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Unplanned Cost', position: 250 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Unplanned Cost', position: 250 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      unplan           : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Other Exp', position: 260 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Other Exp', position: 260 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      oexp             : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Custom Charges', position: 270 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Custom Charges', position: 270 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      custchrge        : abap.curr(10,2);
       @UI.lineItem     : [{label: 'SWS Charges', position: 280 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'SWS Charges', position: 280 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      sws   : abap.curr(10,2);
      @UI.lineItem     : [{label: 'CHA Charges', position: 290 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'CHA Charges', position: 290 }]
      @Semantics.amount.currencyCode : 'DOCUMENTCURRENCY'
      cha              : abap.curr(10,2);
      @UI.lineItem     : [{label: 'Exchange Rate', position: 300 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Exchange rate', position: 300 }]
      KURRF            : abap.char(20);
      @UI.lineItem     : [{label: 'PO NO', position: 310 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'PO NO', position: 310 }]
      ebeln            : ebeln;
      @UI.lineItem     : [{label: 'PO Line Item No', position: 320 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'PO Line Item No', position: 320 }]
      ebelp            : ebelp;
      @UI.lineItem     : [{label: 'Plant', position: 325 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Plant', position: 325 }]
      werks            : werks_d;
      @UI.lineItem     : [{label: 'Payment Due Date', position: 330 ,importance: #HIGH }]
      @UI.identification           : [{ label: 'Payment Due Date', position: 330 }]
      paydt            : datum;
}
