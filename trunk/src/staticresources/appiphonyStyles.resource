/************ Appiphony Style Sheet. Copyright 2008. ************/
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
    margin-top: 0px;
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

div.rightShadow {
	width: 906px;
	margin-left: 0px;
	float: left;
	background-image: url('rightshadow');
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
	font-size: 10px; 
	font-weight: bold;
}
div.authorCrumb a {
	text-decoration: underline;
}
div.authorCrumb a:link {
	text-decoration: underline;
}
div.commentbar .commentLabel {
	font-size: 12px;
	font-weight: bold;
}
/* If you want border, remember that if each border is 1px it is 900 - 2 = width. */
div.pageElement {
    float: left;

}

div.dottedLine {

	border-top: 1px dotted #000000;
	margin-bottom: 20px;
	width: 100%;
}
.commentBox {
	width: 440px;
	height: 200px;
}
div.bottomShade {
	float: left;
	padding: 0px;
	margin-left: 7px;
	width: 904px;
	height: 6px;
	background-image: url("bottomShade");
	background-repeat: repeat-x;
}

/* Elements for accordion pane */
div#accordion {
	border: 1px solid #CCCCCC;
	visibility: hidden;
}

h2.toggle {
    font-size: 8pt;
    font-weight: bold;
	background-color: #EEEEEE;
	display: block;
	padding-top: 0px;
	padding-bottom: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
	height: 37px;
	width: 342px;
	background-image: url("arrow");
	background-repeat: no-repeat;
}

div.appElement {
}

/* MENU DEFS */
div#logoContainer {
    background-image: url("appiphonyLogo");
    height: 62px;
    width: 223px;   
    margin-bottom: 5px;
    margin-top: 5px;
    z-index: 100;
    margin-left: 5px;
}

div#logoContainer h1 {
    display: none;
}

div#phraseContainer {
    background-image: url("phraseBar");
    height: 13px;
	width: 273px;
    z-index: 101;
	margin-top: 15px;
	padding-bottom: 10px;
	background-repeat: no-repeat;
	float: right;
	margin-right: -28px;
}

div#phraseContainer h1 {
	display: none;
}

div#menus {
    font-family: arial, sans-serif;
    font-size: 8pt;
    font-weight: normal;
	float: right;
	text-align: right;
	margin-top: 10px;
	margin-right: 2px;
	width: 100%;
    color: #333333; 
    /*#80878F;*/ 
}

div#menus a {
    font-family: arial, sans-serif;
    font-size: 9pt;
    font-weight: normal;
    color: #333333; 
}

div#menus a:hover {
    font-family: arial, sans-serif;
    font-size: 9pt;
    font-weight: normal;
    color: #990000;
    text-decoration: underline;
}



/* Gray Bar */
div#graybar {
	padding-top: 5px;
	width: 898px;
	height: 20px;
	background-color: #F3F3EC;
	border: 1px solid #CCCCCC;
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








