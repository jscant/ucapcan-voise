#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"
echo Proposition2Check:
$DIR/Proposition2Check

echo GetVDOpCheck:
$DIR/GetVDOpCheck

echo InVectorCheck:
$DIR/InVectorCheck

echo MetricChecks:
$DIR/MetricChecks

echo PoitnInRegionCheck:
$DIR/PointInRegionCheck

echo SqDistanceCheck:
$DIR/SqDistanceCheck

echo testSddSeedCheckLambda:
$DIR/testAddSeedCheckLambda

echo testAddSeedCheckV:
$DIR/testAddSeedCheckV

echo testRemoveSeedCheckLambda:
$DIR/testRemoveSeedCheckLambda

echo testRemoveSeedCheckV:
$DIR/testRemoveSeedCheckV