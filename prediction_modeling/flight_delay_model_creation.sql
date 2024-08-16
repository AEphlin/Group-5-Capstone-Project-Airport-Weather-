CREATE OR REPLACE MODEL `carbide-sweep-428517-c0.opensky_data.flight_delay_model`
OPTIONS(model_type='logistic_reg', input_label_cols=['delayed'],
    l1_reg=0.01,  -- L1 regularization
    l2_reg=0.01   -- L2 regularization
    ) AS
SELECT
    baro_altitude,
    velocity,
    vertical_rate,
    delayed
FROM
    `carbide-sweep-428517-c0.opensky_data.joined_flight_data`
