<?php
/*

   Copyright (c) 2008 Alexey V. Vasilyev

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/
?><?php require_once( dirname( __FILE__ ) . "/redist/colorer.php" ); ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>TEMIS Framework 2.0</title>

    <style>
      code {
      background-color: #E5E5E5;
      display: block;
      }
    </style>
    <link rel="stylesheet" type="text/css" href="index.css"/>
    <link rel="stylesheet" type="text/css" href="redist/colorer.css"/>
  </head>

  <body>
    <div class="title">TEMIS Framework</div>

	<h1>Quick Start</h1>
    <h2>Step 1: Installation</h2>
    <p>
      Install
      <b>TEMIS Framework</b>
      module in &lt;PROJECT_ROOT&gt;/modules/temis
    </p>

	  <h2>Step 2: Configuration</h2>
    <p>
      Configure
      <b>TEMIS Framework</b>
      module for your environment by run
      <a href="../../install">Installation script</a>
      via your browser.
    </p>

    <h2>Step 3: Create server object</h2>
    <p>
      Create page controller*,
      <b>page.php</b> for domain logic:
    </p>
    <code>
      <?php print highlight_file ( dirname( __FILE__ ). "/demo/page.php" , true); ?>
    </code>
    <p>
      * see Martin Fowler, "Enterprise Applications"
    </p>

    <h2>Step 4: Create template</h2>

    <p>
      Create XSLT template
      <b>page.php.xsl</b>:
      (this is standard XSL template except new tags &lt;ui:*&gt;)
    </p>
    <code class="code">
      <?php print sourcecode::html( file_get_contents( dirname( __FILE__ ). "/demo/page.php.xsl") ); ?>
    </code>

    <h1>Sample. How it works</h1>
	<a href="demo/page.php">Demo page </a> or in here in IFRAME:
    (should works if TEMIS Framework are configured.)
    <div style="height:400px;border:2px inset gray;">
      <iframe src="demo/page.php" width="100%" HEIGHT="400px" FRAMEBORDER="0" >
      </iframe>
    </div>
	<script src="../js/toc.js"></script>
	<script>insertTOC();</script>
    <div class="author">
      (c) 2008 Alexei Vasilyev. Some rights reserved.
    </div>
  </body>
</html>
