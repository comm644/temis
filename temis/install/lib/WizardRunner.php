<?php

require_once( dirname(__FILE__) . "/Wizard.php" );
require_once( dirname(__FILE__) . "/WizardTemplate.php" );

class WizardRunner
{

    function WizardRunner($templ) {
        $this->templ = $templ;
    }

    function handle_wizard($m)
    {
        return $this->footerNode. $m;
    }
    function handle_footer($m)
    {
        $this->footerNode = $m;
        //remove footer node
        return "";
    }

    /**
     * This handle required for inner stages.
     *
     * @param string  $stagesTmpl
     * @param array|WizardPage   $pages  pages collection
     * @return string
     */
    function handle_stages($stagesTmpl, $pages)
    {

        $rx = new WizardTemplate();
        return $rx->replace($stagesTmpl, array(
            'stage' => array($this, 'handle_stage', array( 'tmpl' => $stagesTmpl, 'pages' => $pages) )
            ));
    }
    
    function handle_stage($stageTmpl, $context)
    {

        if ($context['pages'] == 0){
            return '';
        }

        $result = array();

        foreach ($context['pages'] as $page) {
            $result[] = str_replace(
                            array("{{page-id}}", "{{active}}", "<install:stage-name/>"),
                            array($page->id, $page->active, $page->caption),
                            $stageTmpl);


            $innerContext = $context;
            $innerContext['pages']= $page->pages();

            $rx = new WizardTemplate();
	    if ( isset( $context['stagesTmpl'] )) {
            $result[] = $rx->replace( $context['stagesTmpl'],
                    array( 'stage' => array( $this, 'handle_stage', $innerContext )
                    ));
            }

        }
        return implode('', $result);
    }

    function handle_button($m, $isVisible)
    {

        return $isVisible ? $m : '';
    }
    

    function run(&$wizard)
    {
        if (!$wizard->currentStage)
            return;

        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            if ($_REQUEST["action"] == 'next') {
                $wizard->next();
            } else {
                $wizard->prev();
            }

            //reload window by GET method
            echo "<html><head><script>window.location.href=window.location.href;</script></head></html>";
            return;
        }



        $tmpl = file_get_contents($this->templ);
        $rx = new WizardTemplate();


        //move footer to top node.
        $tmpl = $rx->replace( $tmpl,
                array(
                    "footer" => array( $this, 'handle_footer' ),
                    "stages" => array( $this, 'handle_stages', $wizard->pages()),
                    "wizard" => array( $this, 'handle_wizard')
                ));

        
        list( $head, $tail ) = explode("<install:report/>", $tmpl);

        echo $head;
        flush();

        $rc = $wizard->currentStage->run();

        $tail = $rx->replace($tail,
                        array(
                            'back' => array($this, 'handle_button', $wizard->canMovePrev()),
                            'next' => array($this, 'handle_button', $rc && $wizard->canMoveNext()),
                            'error' => array($this, 'handle_button', !$rc)
                          ));
        echo $tail;
        flush();
    }

}
