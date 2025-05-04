#!/bin/bash

set -e
set -o pipefail

#docker run -u $(id -u):$(id -g) -v $(pwd):/working_dir --rm agostini01/soda \
#  tf-mlir-translate \
#    --graphdef-to-mlir \
#    --tf-input-arrays=vxm_dense_source_input,vxm_dense_target_input \
#    --tf-input-data-types=DT_FLOAT,DT_FLOAT \
#    --tf-input-shapes=4,32,230,288,1:4,32,230,288,1 \
#    --tf-output-arrays=Identity,Identity_1 \
#    $1 \
#    -o output/tf.mlir

docker run -u $(id -u):$(id -g) -v $(pwd):/working_dir --rm agostini01/soda \
  tf-mlir-translate \
    --graphdef-to-mlir \
    --tf-input-arrays=fixed,moving \
    --tf-input-data-types=DT_FLOAT,DT_FLOAT \
    --tf-input-shapes=128,128,128,1:128,128,128,1 \
    --tf-output-arrays=Identity,Identity_1 \
    $1 \
    -o output/tf.mlir

docker run -u $(id -u):$(id -g) -v $(pwd):/working_dir --rm agostini01/soda \
tf-opt \
  --tf-executor-to-functional-conversion \
  --tf-region-control-flow-to-functional \
  --tf-shape-inference \
  --tf-to-tosa-pipeline \
  output/tf.mlir \
  -o $2


 
#  --tf-region-control-flow-to-functional \
#  --tf-shape-inference \
#  --tf-to-tosa-pipeline \