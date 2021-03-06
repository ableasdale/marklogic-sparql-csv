xquery version "1.0-ml";

declare variable $BASE-QUERY as xs:string := "# SPARQL Query to be evaluated

SELECT DISTINCT * WHERE {?s ?p ?o} LIMIT 10";

declare variable $TEXTAREA-ELEMENT-ID-NAME as xs:string := "data";
declare variable $CONTENT-SOURCE as xs:string := xdmp:get-request-field("database", "Documents");

(:
declare function local:database-select() as element(div) {
    element div {attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle"},
            attribute type {"button"},
            attribute id {"database-select"},
            attribute name {"database"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose database ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"database-select"},
            element li {attribute class {"dropdown-header"}, "Available Databases:"},
            for $x in xdmp:database-name(xdmp:databases())
            return
                element li {element a {attribute href {"#"}, $x}}
        }
    }
}; :)

declare function local:db-chooser-dropdown($state as xs:string) {
    <div class="form-group">
        <label for="database">Content Source:</label>
        <select class="form-control" name="database">
            {
            for $x in xdmp:database-name(xdmp:databases())
            return element option {attribute value {$x},
                if ($state eq $x)
                then (attribute selected {"selected"})
                else(),
            $x}
            }
        </select>
    </div>
};

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
            <script><![CDATA[{var myCodeMirror = CodeMirror.fromTextArea(document.getElementById("data"), {lineNumbers: true, mode: "application/sparql-query", matchBrackets: true});}]]></script>
        }
    }
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html>',
local:create-bootstrap-page("MarkLogic SPARQL Query to CSV",
    element div {attribute class {"container"},
        element form {attribute method {"post"}, attribute action {"/process-query.xqy"}, attribute enctype {"application/x-www-form-urlencoded"},
            element div {attribute class {"row"},
                element div {attribute class {"col-md-8"}, element h2 {"SPARQL Query ", element small {"Editor"}}},
                element div {attribute class {"col-md-4"}, local:db-chooser-dropdown($CONTENT-SOURCE)}
            },
            element div {attribute class {"row"},
            <div class="form-group">
                <label class="col-sm-2 control-label" for="format">Output Format:</label>
                <div class="col-sm-4">
                    <select class="form-control" name="format">
                    {
                    for $x in ("csv", "zip")
                        return element option {attribute value {$x}, $x}
                    }
                    </select>
                </div>
            </div>
            },
            element hr {},
            element textarea {attribute name {"query"}, attribute id {"data"}, $BASE-QUERY},
            element hr {},
            element button {attribute type {"submit"}, attribute class {"btn btn-primary"},
            element span {attribute class {"glyphicon glyphicon-download"}," "}, " Execute Query and Download File"}
        }
    })