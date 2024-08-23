{% macro ax_update_watermarkvalue(branch='develop') %}

    {% set sql_copy %}

        use schema {{ generate_schemaname(branch,'AX') }};

        copy into '@azure_stage/BOM/BOM.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from BOM) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/CUSTINVOICETRANS/CUSTINVOICETRANS.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from CUSTINVOICETRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/ECORESATTRIBUTEVALUE/ECORESATTRIBUTEVALUE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from ECORESATTRIBUTEVALUE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/ECORESVALUE/ECORESVALUE.csv' from (select max(DATETIMEVALUETZID) as LASTMODIFIEDDATETIME from ECORESVALUE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/GL_QueryTabel (Query Table)/GL_QueryTabel (Query Table).csv' from (select max(GJE_ACCOUNTINGDATE) as LASTMODIFIEDDATETIME from GL_QUERYTABLE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/INVENTDIM/INVENTDIM.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from INVENTDIM) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/INVENTITEMBARCODE/INVENTITEMBARCODE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from INVENTITEMBARCODE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/INVENTITEMPRICE/INVENTITEMPRICE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from INVENTITEMPRICE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/INVENTSUM/INVENTSUM.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from INVENTSUM) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/INVENTTRANS/INVENTTRANS.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from INVENTTRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/MASDOORTABLE/MASDOORTABLE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from MASDOORTABLE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PRODCALCTRANS/PRODCALCTRANS.csv' from (select max(TRANSDATE) as LASTMODIFIEDDATETIME from PRODCALCTRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PRODJOURNALPROD/PRODJOURNALPROD.csv' from (select max(TRANSDATE) as LASTMODIFIEDDATETIME from PRODJOURNALPROD) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PRODJOURNALROUTE/PRODJOURNALROUTE.csv' from (select max(TRANSDATE) as LASTMODIFIEDDATETIME from PRODJOURNALROUTE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PRODJOURNALTABLE/PRODJOURNALTABLE.csv' from (select max(POSTEDDATETIME) as LASTMODIFIEDDATETIME from PRODJOURNALTABLE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PRODROUTETRANS/PRODROUTETRANS.csv' from (select max(DATEWIP) as LASTMODIFIEDDATETIME from PRODROUTETRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/PURCHLINE/PURCHLINE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from PURCHLINE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/SALESLINE/SALESLINE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from SALESLINE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/VENDINVOICETRANS/VENDINVOICETRANS.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from VENDINVOICETRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/VENDTRANS/VENDTRANS.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from VENDTRANS) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/WHSLOADLINE/WHSLOADLINE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from WHSLOADLINE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);
        
        copy into '@azure_stage/WHSLOADTABLE/WHSLOADTABLE.csv' from (select max(MODIFIEDDATETIME) as LASTMODIFIEDDATETIME from WHSLOADTABLE) OVERWRITE=TRUE SINGLE=TRUE HEADER=TRUE FILE_FORMAT = (TYPE=CSV,COMPRESSION=NONE);

    {% endset %}

    {% do run_query(sql_copy) %}


{% endmacro %}
