xquery version "1.0-ml";

declare variable $TARGET-DB as xs:string := xdmp:get-request-field("database");
declare variable $PAYLOAD as xs:string := xdmp:get-request-field("query");
declare variable $FORMAT as xs:string := xdmp:get-request-field("format");

declare variable $RESULTSET := xdmp:eval-in(("sem:sparql("""||$PAYLOAD||""")"), xdmp:database($TARGET-DB));

declare variable $DATA := (string-join(map:keys($RESULTSET[1]),","),
for $i in $RESULTSET return string-join(for $key in map:keys($i) return map:get($i, $key) cast as xs:string, ","));

if ($FORMAT eq "csv")
then (
xdmp:set-response-content-type("application/csv"),
xdmp:add-response-header("Content-Disposition", "attachment; filename=sparql-query.csv"),
$DATA
) else (
xdmp:set-response-content-type("application/zip"),
xdmp:add-response-header("Content-Disposition", "attachment; filename=sparql-query.zip"),
xdmp:zip-create(
<parts xmlns="xdmp:zip">
<part>sparql-query.csv</part>
</parts>,
($DATA))
)
