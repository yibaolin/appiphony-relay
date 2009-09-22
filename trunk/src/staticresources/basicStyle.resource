/************ Basic Style Sheet for Attercop (Appiphony's Blog Package) ************/
/* Many thanks to Anthony Ina of Smarticle.com for ideas... */

/************ Base redefinitions ************/
body {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 8pt;
    font-weight: normal;
    color: #000000;
    background-color: #FFFFFF;
    text-align: center;
    min-width: 900px;
    margin-top: 15px;
    margin-bottom: 0px;
    line-height: 120%;
}

img {
    border: 0px;
    padding: 0px;
}

h1 {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 16pt;
    font-weight: normal;
    padding-bottom: 10px;
    color: #000000;
}

h2 {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    color: #000000;
    /*#990000;*/
    /*993300;*/
}

h2 a {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    text-decoration: none;
    color: #990000;
    /*#990000;*/
    /*993300;*/
    cursor: pointer;
}

h2 a:hover {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    color: #990000;
    cursor: pointer;
}

h3 {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    color: #000000; 
}

h3 a {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    text-decoration: none;
    color: #000000; 
    cursor: pointer;
}

h3 a:hover {
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-size: 10pt;
    font-weight: bold;
    text-decoration: none;
    color: #000000; 
    cursor: pointer;
}


/* Hyperlink setup. */
a {
    color: #006699; 
    /*#3399CC;*/
    /*#7c7c7c;*/
    text-decoration: none;
    cursor: pointer;
}

a:hover {
    color: #006699;
    text-decoration: underline;
    cursor: pointer;
}

hr {
	height: 1px;
	background-color: #CCCCCC;
	color: #CCCCCC;
	border: 0;
}

.grey-out {
    color: #999999;
}

.dynamic {
    color: #FF0600;
}

.dynamic a {
    color: #FF0600;
    text-decoration: none;
    cursor: pointer;
}

.dynamic a:hover {
    color: #FF0600;
    text-decoration: underline;
}

/* Used to pad text in divs that have 'ems */
.news-in {
    padding-left: 5px;
    padding-top: 2px;
    color: #000000;
    font-weight: bold;
}

.news-in .unbold {
    font-weight: normal;
    color: #333333;
}

.news-in a {
    color: #333333;
    /*color: #3399CC;*//*#FF0600;*/
    text-decoration: none;
    cursor: pointer;
    font-weight: bold;
    margin-top: 5px;
}

.news-in a:hover {
    /*color: #990000;
    text-decoration: underline;
    font-weight: normal;*/
}

.text-in {
    padding-left: 10px;
    padding-right: 10px;

}


/* Regular link Format */
a.regularLink, a.regularLink:link, a.regularLink:active, a.regularLink:hover, a.regularLink:visited {
    color: #666666;
    text-decoration: none;
}

a.regularLink:hover {
    text-decoration: underline;
}


/************ Page constructs ************/
/* This guy sets the width and centers the page. */
div#pageContainer {
    /* Sub contents will be smaller if they have borders, etc... */
    width: 918px;
    margin: 0 auto;
    text-align: left;
    background-color: #FFFFFF;
    margin-top: 0px;
}

/* Set the body block container */
div#pageBody {
    padding: 0px;
    margin-left: 0px;
    width: 898px;
    /* This would set the border for the entire page. */
    float: left;
	/* border-left: 1px solid #CCCCCC;
	border-right: 1px solid #CCCCCC;
	border-bottom: 1px solid #CCCCCC;
	border-top: 1px solid #CCCCCC; */
}

/* Inner Page Div border'd contianer */
div.authorCrumb {
	float: right;
	font-size: 6pt;
}


/* If you want border, remember that if each border is 1px it is 900 - 2 = width. */
div.pageElement {
    float: left;
}



div.appElement {
}



/* Gray Bar */
div#graybar {
	padding-top: 5px;
	width: 898px;
	height: 20px;
	background-color: #F3F3EC;
	border: 1px solid #CCCCCC;
	float: left;
	margin-bottom: 10px;
}

.commentbar {
	padding-top: 2px;
	background-color: #F3F3EC;
	border: 1px solid #CCCCCC;
	margin-bottom: 2px;
}


/* FORM ELEMENTS */



/* FOOTER DEFS */
div.pageInfo {
    width: 898px;
    float: left;
    background-color: #FFFFFF;
    padding-top: 5px;
    padding-bottom: 10px;
}

div.pageInfo div.rSide{
    color: #7c7c7c;
    font-size: 10px;
    float: right;
    text-align: right;
}

div.pageInfo div.rSide a {
    color: #7c7c7c;
    text-decoration: none;
}

div.pageInfo div.rSide a:hover{
    color: #FF0600;
    text-decoration: none;
}

div.pageInfo div.lSide{
    color: #7c7c7c;
    font-size: 10px;
    float: left;
    text-align: left;
}

div.pageInfo div.lSide a {
    color: #7c7c7c;
    text-decoration: none;
}

div.pageInfo div.lSide a:hover{
    color: #FF0600;
    text-decoration: none;
}

/*MOOTREE Directives */
.mooTree_node {
	/* font-family: Verdana, Arial, Helvetica; */
	/* font-size: 10px; */
	white-space: nowrap;
}

.mooTree_text {
    color: #006699; 
	padding-top: 3px;
	height: 15px;
	cursor: pointer;
}

.mooTree_img {
	float: left;
	width: 18px;
	height: 18px;
	overflow: hidden;
}

.mooTree_selected	 {
	font-weight: bold;
}

.inputSearch {
	border: 1px solid red;
}

.pseudoButton {
    border-bottom: 1px solid #5C5D61;
    border-right: 1px solid #5C5D61;
    padding-left: 5px;
    padding-right: 5px;
    padding-top: 2px;
    padding-bottom: 2px;
    background-color: #9399A5;
    color: white;
    font-family: 'Verdana','Arial','Helvetica', sans-serif;
    font-weight: bold;
    font-size: 10px;
    display: inline;
    cursor: pointer;
    text-decoration: none;
}







