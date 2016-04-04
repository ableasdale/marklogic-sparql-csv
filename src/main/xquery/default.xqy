xquery version "1.0-ml";

declare variable $BASE-QUERY as xs:string := "# SPARQL Query to be evaluated

SELECT DISTINCT * WHERE {?s ?p ?o} LIMIT 10";

declare function local:create-bootstrap-page($title as xs:string, $content as element()){
    element html {attribute lang {"en"},
        element head {
            element meta {attribute charset {"utf-8"}},
            element meta {attribute http-equiv {"X-UA-Compatible"}, attribute content {"IE=edge"}},
            element meta {attribute name {"viewport"}, attribute content {"width=device-width, initial-scale=1"}},
            element title {$title},
            element link {
                attribute rel {"stylesheet"},
                attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"},
                attribute integrity {"sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"},
                attribute crossorigin {"anonymous"}
            },
            element link {
                attribute rel {"stylesheet"},
                attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"},
                attribute integrity {"sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r"},
                attribute crossorigin {"anonymous"}
            },
            element link {
                attribute rel {"stylesheet"},
                attribute href {"https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/codemirror.min.css"}}
        },
        element body {
            $content,
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">{" "}</script>,
            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/codemirror.min.js">{" "}</script>,
            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/mode/sparql/sparql.min.js">{" "}</script>,
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous">{" "}</script>,
            <script><![CDATA[{var myCodeMirror = CodeMirror.fromTextArea(document.getElementById("code"), {lineNumbers: true, mode: "application/sparql-query", matchBrackets: true});}]]></script>
        }
    }
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html>',
local:create-bootstrap-page("bootstrap 101 template",
    element div {
        attribute class {"container"},
        element h2 {"SPARQL Query ", element small {"Editor"}},
        element form {
            element textarea {attribute id {"code"}, $BASE-QUERY},
            element hr {},
            element button {attribute type {"submit"}, attribute class {"btn btn-primary"},
            element span {attribute class {"glyphicon glyphicon-download"}," "}, " Execute and Download (CSV)"} (:," ",
            element button {attribute type {"button"}, attribute class {"btn btn-primary"},
            element span {attribute class {"glyphicon glyphicon-download"}," "}, " Execute and Download (ZIP)"} :)
        }
    })