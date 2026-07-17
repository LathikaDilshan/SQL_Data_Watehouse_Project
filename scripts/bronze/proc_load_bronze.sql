/*
=====================================================================================
Stored procedure : Load Bronze Layer
=====================================================================================
Script Purpose:
  This stored loads data into the bronze schema from external cvs file
  IT performs the following actions
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from csv files to bronze tables

Usage Example:
    CALL bronze.load_bronze();
======================================================================================
*/






CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
    -- Variables must be declared before BEGIN
    batch_start_time TIMESTAMP;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    duration NUMERIC;
BEGIN
    -- Capture the exact moment the entire procedure starts
    batch_start_time := clock_timestamp();

    RAISE NOTICE '==================================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '==================================================================';

    RAISE NOTICE '------------------------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------------------------';
    
    -- 1. Load crm_cust_info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info FROM 'C:/pg_data/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    -- 2. Load crm_prd_info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info FROM 'C:/pg_data/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    -- 3. Load crm_sales_details
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details FROM 'C:/pg_data/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    RAISE NOTICE '------------------------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------------------------';

    -- 4. Load erp_cust_az12
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12 FROM 'C:/pg_data/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    -- 5. Load erp_loc_a101
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101 FROM 'C:/pg_data/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    -- 6. Load erp_px_cat_g1v2
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2 FROM 'C:/pg_data/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true);
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration;
    RAISE NOTICE '-----------------';

    -- Calculate total batch duration
    end_time := clock_timestamp();
    duration := EXTRACT(EPOCH FROM (end_time - batch_start_time));

    RAISE NOTICE '==================================================================';
    RAISE NOTICE 'Bronze Layer Loaded Successfully';
    RAISE NOTICE '>> Total Load Duration: % seconds', duration;
    RAISE NOTICE '==================================================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==================================================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOAD';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error State: %', SQLSTATE;
        RAISE NOTICE '==================================================================';
        
        RAISE;
END;
$$;
