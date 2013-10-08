<?php
  //исполняется в uiPage::render() страница сама отвечает за свое отображение  
  $node = $this;
  ?><html>
    <body bgcolor="#FFFFFF">
    <?php
       function genAttr_1234($node) { 
           echo 'value="'. (isset( $node->viewstate ) ? $node->viewstate : null) . '"';
       };
       ?> 
       <input type="hidden" name="__viewstate" <?php echo genAttr_1234($node) ?>
       </input>
       <?php echo $node->text ?>
     </body>
  </html>

