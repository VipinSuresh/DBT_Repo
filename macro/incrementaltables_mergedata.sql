{% macro ax_incrementaltables_mergedata(branch='develop') %}

    {% set create_dynamic_sql %}
        
        use schema {{ generate_schemaname(branch,'CONFIG_RAW') }};

        SELECT DISTINCT CONCAT('MERGE INTO '||DatabaseName||'.'||SchemaName||'.'||TargetTableName|| ' AS tgt'
                        || ' USING '||DatabaseName||'.'||SchemaName||'.'||SourceTableName|| ' AS src'
                        || ' ON '||KeyColumn 
                        || ' WHEN MATCHED THEN '
                        || ' UPDATE SET '||UpdateColList 
                        || ' WHEN NOT MATCHED THEN '
                        || ' INSERT ('||InsertColList ||')'
                        || ' VALUES ('||InsertColList ||');') AS MergeQry
        FROM (
                SELECT DISTINCT 
                TargetTableName,
                SourceTableName,
                SchemaName,
                DatabaseName,              
                LTRIM(ARRAY_TO_STRING((SELECT ARRAY_AGG(' ,  '|| 'tgt.'||UC.Column_Name||' = src.'||UC.Column_Name)
                                        FROM information_schema.COLUMNS  UC 
                                        LEFT JOIN 
                                            (SELECT  TargetTableName,SchemaName,UPPER(VALUE) AS KeyColumn
                                                FROM  IncrementalTable_Config,LATERAL STRTOK_SPLIT_TO_TABLE(IncrementalTable_Config.PRIMARYKEY, ',')) pk
                                        ON UC.Table_Name=UPPER(pk.TargetTableName)
                                        AND UC.Column_Name=UPPER(pk.KeyColumn)
                                        AND UC.Table_Schema=UPPER(pk.SchemaName)
                                        WHERE UC.Table_Name=UPPER(Conf.TargetTableName)
                                        AND UC.Table_Schema=UPPER(Conf.SchemaName)
                                        AND KeyColumn IS NULL
                                                                
                            ),' '),' ,') AS UpdateColList,
                LTRIM(ARRAY_TO_STRING((SELECT ARRAY_AGG(' ,  '||UC.Column_Name)
                                        FROM information_schema.COLUMNS  UC 
                                        WHERE UC.Table_Name=UPPER(Conf.TargetTableName)
                                        AND UC.Table_Schema=UPPER(Conf.SchemaName)                          
                            ),' '),' ,') AS InsertColList,
                LTRIM(ARRAY_TO_STRING((SELECT ARRAY_AGG(' AND  tgt.'||KeyColumn||' = src.'||KeyColumn) 
                                        FROM  (SELECT  TargetTableName,SchemaName,UPPER(VALUE) AS KeyColumn
                                                FROM  IncrementalTable_Config,LATERAL STRTOK_SPLIT_TO_TABLE(IncrementalTable_Config.PRIMARYKEY, ',')) pk
                                        WHERE TargetTableName= Conf.TargetTableName And SchemaName = Conf.SchemaName)
                                        
                            ,' '),' AND') AS KeyColumn
        
                FROM IncrementalTable_Config Conf Where SchemaName = '{{ generate_schemaname(branch,'AX') }}'
                
            ) as tbl
    {% endset %}

    {% set results = run_query(create_dynamic_sql) %}

    {% set Update_query = results %}

    {% if execute %}
        {% set a1 = Update_query.columns[0].values() %}
    {% endif %}
 
    {% for qry in a1 %}
 
        {% set sql_execute_qury %}    

        {{ qry }}        

        COMMIT;
    
    {% endset %}
 
  {% do run_query(sql_execute_qury) %}
 
{% endfor %}
 
{% endmacro %}
