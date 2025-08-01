CLASS zcl_purchase_register2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PURCHASE_REGISTER2 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA : lv_refdoc TYPE i_accountingdocumentjournal-referencedocument .
    DATA: lt_response TYPE TABLE OF zce_pur_register1,
          ls_response TYPE zce_pur_register1.
    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).

    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    DATA(lr_fkdat)   =  VALUE #( lt_filter_cond[ name   = 'POSTINGDATE' ]-range OPTIONAL ).
    select FROM I_SUPPLIERINVOICEAPI01 as a
            join I_SUPLRINVCITEMPURORDREFAPI01 as b
            on ( a~SupplierInvoice = b~SUPPLIERINVOICE )

            FIELDS a~POSTINGDATE,
                   a~DOCUMENTDATE,
                   a~SUPPLIERINVOICE,
                   a~SUPPLIERINVOICEIDBYINVCGPARTY,
                   a~INVOICINGPARTY,
                   a~INVOICEGROSSAMOUNT,
                   a~DOCUMENTCURRENCY,
                   a~ExchangeRate,
                   b~SUPPLIERINVOICEITEM,
                   b~PURCHASEORDERITEMMATERIAL,
                   b~QUANTITYINPURCHASEORDERUNIT,
                   b~PURCHASEORDERQUANTITYUNIT,
                   b~SUPPLIERINVOICEITEMAMOUNT,
                   b~TAXCODE,
                   b~SUPLRINVCITMUNPLNDDELIVCOST,
                   b~PURCHASEORDER,
                   b~PURCHASEORDERITEM,
                   b~PLANT,
                   b~SupplierInvoiceItemText
           WHERE a~POSTINGDATE in @lr_fkdat
           order BY a~SUPPLIERINVOICE , b~SUPPLIERINVOICEITEM
           into TABLE @DATA(lt_data)
           UP TO @lv_top ROWS OFFSET @lv_skip.

      select from I_SUPLRINVCITEMPURORDREFAPI01 fields SUPPLIERINVOICE,
             SUPPLIERINVOICEITEM,
             SUPPLIERINVOICEITEMAMOUNT,
             SUPLRINVCDELIVERYCOSTCNDNTYPE
          for ALL ENTRIES IN @lt_data
          where SUPPLIERINVOICE = @lt_data-SupplierInvoice
          INTO TABLE @data(lt_item)  .


    if lt_data[] is NOT INITIAL.
    LOOP AT lt_data INTO DATA(ls_data).
     ls_response-POSTINGDATE = ls_data-PostingDate.
     ls_response-DOCUMENTDATE = ls_data-DOCUMENTDATE.
     ls_response-purinvno = ls_data-SUPPLIERINVOICE.
     ls_response-supinvno = ls_data-SUPPLIERINVOICEIDBYINVCGPARTY.
     ls_response-supname = ls_data-INVOICINGPARTY.
     ls_response-totamt = ls_data-INVOICEGROSSAMOUNT.
     ls_response-DOCUMENTCURRENCY = ls_data-DOCUMENTCURRENCY.
     ls_response-KURRF = ls_data-ExchangeRate.
     ls_response-ebeln = ls_data-PurchaseOrder.
     ls_response-ebelp = ls_data-PurchaseOrderItem.
     ls_response-werks = ls_data-Plant.
     ls_response-uom = ls_data-PURCHASEORDERQUANTITYUNIT.
     ls_response-fkimg = ls_data-QUANTITYINPURCHASEORDERUNIT.
     ls_response-netamt = ls_data-SUPPLIERINVOICEITEMAMOUNT.
     ls_response-taxcode = ls_data-TAXCODE.
     ls_response-unplan = ls_data-SUPLRINVCITMUNPLNDDELIVCOST.
     ls_response-matnr = ls_data-PURCHASEORDERITEMMATERIAL.
     ls_response-itemno = ls_data-SupplierInvoiceItem.
     ls_response-Invtext = ls_data-SupplierInvoiceItemText.

    loop at lt_item INTO DATA(ls_item) where SUPPLIERINVOICE = ls_data-SUPPLIERINVOICE AND SupplierInvoiceItem = ls_data-SupplierInvoiceItem.
        CASE ls_item-SUPLRINVCDELIVERYCOSTCNDNTYPE.
*          WHEN 'PR00'.
          WHEN 'ZLFV' or 'ZLF1'.
            ls_response-freight = ls_item-SupplierInvoiceItemAmount.
          WHEN 'Z'.
            ls_response-pack = ls_item-SupplierInvoiceItemAmount.
          WHEN 'ZIIV'.
            ls_response-insurence = ls_item-SupplierInvoiceItemAmount.
          WHEN 'ZOTC'.
            ls_response-oexp = ls_item-SupplierInvoiceItemAmount.
          WHEN 'ZJCD'.
            ls_response-custchrge = ls_item-SupplierInvoiceItemAmount.
         WHEN 'ZJSC'.
            ls_response-SWS = ls_item-SupplierInvoiceItemAmount.
         WHEN 'ZCHA'.
            ls_response-cha = ls_item-SupplierInvoiceItemAmount.
        ENDCASE.

    endloop.
     APPEND ls_response to lt_response.
     clear : LS_ITEM, ls_response.

    ENDLOOP.

    io_response->set_total_number_of_records( lines( lt_data ) ).
    io_response->set_data( lt_response ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
