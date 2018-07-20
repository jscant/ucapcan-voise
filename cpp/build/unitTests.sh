DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"
$DIR/GetVDOpCheck
$DIR/InVectorCheck
$DIR/MetricChecks
$DIR/PointInRegionCheck
$DIR/SqDistanceCheck
$DIR/testAddSeedCheckLambda
$DIR/testAddSeedCheckV
$DIR/testRemoveSeedCheckLambda
$DIR/testRemoveSeedCheckV