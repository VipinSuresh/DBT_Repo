{% macro generate_schemaname(branch='',inputschema='') %}

    {% if inputschema == 'AX' %}
        {% if branch == 'master' %}
            {% set schemaname = '' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = '' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = '' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == '' %}
        {% if branch == 'master' %}
            {% set schemaname = '' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = '' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = '' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == '' %}
        {% if branch == 'master' %}
            {% set schemaname = '' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = '' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = '' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'EXCELMDM' %}
        {% if branch == 'master' %}
            {% set schemaname = 'EXCELMDM' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'EXCELMDM_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'EXCELMDM_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'INFOR' %}
        {% if branch == 'master' %}
            {% set schemaname = 'INFOR' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'INFOR_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'INFOR_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'ORACLE' %}
        {% if branch == 'master' %}
            {% set schemaname = 'ORACLE' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'ORACLE_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'ORACLE_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'SQL_LONDON' %}
        {% if branch == 'master' %}
            {% set schemaname = 'SQL_LONDON' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'SQL_LONDON_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'SQL_LONDON_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'SQL_MC' %}
        {% if branch == 'master' %}
            {% set schemaname = 'SQL_MC' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'SQL_MC_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'SQL_MC_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'SQL_SPRINGFIELD' %}
        {% if branch == 'master' %}
            {% set schemaname = 'SQL_SPRINGFIELD' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'SQL_SPRINGFIELD_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'SQL_SPRINGFIELD_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

    {% if inputschema == 'CONFIG_RAW' %}
        {% if branch == 'master' %}
            {% set schemaname = 'CONFIG_RAW' %}
        {% else %}
            {% if branch == 'staging' %}
                {% set schemaname = 'CONFIG_RAW_QA' %}
            {% else %}
                {% if branch == 'develop' %}
                    {% set schemaname = 'CONFIG_RAW_DEV' %}
                {% endif %}
            {% endif %}
        {% endif %}
    {% endif%}

{{ return(schemaname) }}
{% endmacro %}
