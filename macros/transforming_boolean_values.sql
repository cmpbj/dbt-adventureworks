{% macro transforms_boolean_values(column_name) %}


{%- if execute %}
    case
        when {{ column_name }} = true then 1
        when {{ column_name }} = false then 0
        else null
    end
{%- endif -%} 
    
    
{% endmacro %}