<?php
require_once( dirname(__FILE__)."/../lib/Wizard.php" );
require_once( dirname(__FILE__)."/../lib/ContainerPage.php" );

class BasePage extends WizardPage
{

	function run()
	{
		//print "run page: {$this->id}\n";
	}
}

class ComplexPage extends ContainerPage
{
	function construct()
	{
		$this->wizard = new Wizard('inner_guid', 'inner0' );
		$this->wizard->add( new BasePage('inner0', 'Inner page 0') );
		$this->wizard->add( new BasePage('inner1', 'Inner page 1') );
	}
}

class testWizard extends PhpTest_Testsuite
{
	function test1()
	{
		@session_start();
		
		$wizard = new Wizard('main_guid', 'page0');
		$wizard->add( new BasePage( 'page0', 'primary page0'));
		$wizard->add( new ComplexPage( 'page1', 'complex page1'));
		$wizard->add( new BasePage( 'page2', 'primary page2'));
		$wizard->selectStep();

		//forward

		TS_ASSERT_EQUALS( 'page0', $wizard->currentStage->id );
		
		$wizard->run();
		$wizard->next();
		
		TS_ASSERT_EQUALS( 'page1', $wizard->currentStage->id );

		$wizard->run();
		TS_ASSERT_EQUALS( 'inner0', $wizard->currentStage->wizard->currentStage->id );
		
		$wizard->next();
		TS_ASSERT_EQUALS( 'page1', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( 'inner1', $wizard->currentStage->wizard->currentStage->id );
		TS_ASSERT_EQUALS( true, $wizard->canMoveNext() );

		$wizard->run();
		$wizard->next();

		TS_ASSERT_EQUALS( 'page2', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( false, $wizard->canMoveNext() );

		$wizard->run();
		$wizard->next();
		//should stay on end
		TS_ASSERT_EQUALS( 'page2', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( false, $wizard->canMoveNext() );

		$wizard->run();
		
		//backward
		$wizard->prev();
		$wizard->run();

		TS_ASSERT_EQUALS( 'page1', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( 'inner1', $wizard->currentStage->wizard->currentStage->id );

		$wizard->prev();
		$wizard->run();

		TS_ASSERT_EQUALS( 'page1', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( 'inner0', $wizard->currentStage->wizard->currentStage->id );
		TS_ASSERT_EQUALS( true, $wizard->canMovePrev() );

		$wizard->prev();
		$wizard->run();

		TS_ASSERT_EQUALS( 'page0', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( false, $wizard->canMovePrev() );

		$wizard->prev();
		$wizard->run();

		//should stay on begin
		TS_ASSERT_EQUALS( 'page0', $wizard->currentStage->id );
		TS_ASSERT_EQUALS( false, $wizard->canMovePrev() );
	}
}

?>