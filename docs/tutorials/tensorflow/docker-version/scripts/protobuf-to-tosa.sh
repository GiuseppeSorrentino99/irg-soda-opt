#!/bin/bash
set -e
set -o pipefail

INPUT_GRAPH=$1
OUTPUT_TOSA=$2

docker run -u $(id -u):$(id -g) -v $(pwd):/working_dir --rm agostini01/soda \
  tf-mlir-translate \
    --graphdef-to-mlir \
    --tf-input-arrays=vxm_dense_source_input,vxm_dense_target_input \
    --tf-input-data-types=DT_FLOAT,DT_FLOAT \
    --tf-input-shapes="4,32,288,288,1;4,32,288,288,1 "\
    --tf-output-arrays=Identity,Identity_1 \
    "$INPUT_GRAPH" \
    -o tf.mlir

docker run -u $(id -u):$(id -g) -v $(pwd):/working_dir --rm agostini01/soda \
  tf-opt \
    --tf-executor-to-functional-conversion \
    --tf-region-control-flow-to-functional \
    --tf-shape-inference \
    --tf-to-tosa-pipeline \
    tf.mlir \
    -o "$OUTPUT_TOSA"
