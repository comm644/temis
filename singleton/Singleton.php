<?php
/******************************************************************************
 Copyright (c) 2005-2009 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : Singleton pattern
 File       : Singleton.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/


  /** \ingroup patterns

  Class implement singleton support object
   */
class Singleton
{
	function _get_singletonName()
	{
		$class=  get_class( $this );
		$name= "singleton_".$class;
		return $name;
	}
			
	
	/** get object instance
	 * 
	 * @return mixed inherited class instances
	 */
	function &getInstance()
	{
		$class=  get_class( $this );
		$name = $this->_get_singletonName();
		global $$name;

		if ( !isset( $$name ) || is_null( $$name )) {
			$$name = new $class();
			return $$name;
		}
		return $$name;
	}

	/** set object instance.
	 @param mixed $obj what an object need set
     @return mixed received value
	 */
	function &setInstance( $obj )
	{
		$name = $this->_get_singletonName();
		global $$name;

		$$name = $obj;
		return $$name;

	}
	
	/**
	 * This method provides service for creating 'instance driving' frontend.
	 * \para
	 * If you want to use static methods such as :  Subsystem::method();
	 * and also wants use singleton feature, with some initialization before using.
	 * You can create proxy class and substitute Subsystem class by generated proxy class.    
	 *
	 *  \para
	 * This feature also can be described as pattern State (see GOF) , 
	 *  where 'State' is original Subsystem class
	 * 
	 * @param string  $frontendName
	 * @return string class code wich was used in eval();
	 */
	function createFrontend($frontendName)
	{
		$instance = $this->getInstance(); //create one instance for front-end
		
		$sourceClass = get_class( $this);
		$methods= get_class_methods($sourceClass);
		$singletonName = $this->_get_singletonName();
		
		$code = "\nclass {$frontendName} \n{ \n";
		$endl = "\n";
		$tab = "\t";
		$tab2 = $tab . $tab;
		
		$static = ( version_compare(PHP_VERSION, '5.0.0')>= 0) ? 'static ' : '';
		foreach( $methods as $method ) {
			$code .= $tab . sprintf( $static .'function %s(){', $method ) . $endl;
			$code .= $tab2 . sprintf( 'global $%s;', $singletonName) . $endl;
			$code .= $tab2 . '$args = func_get_args();' . $endl;
			$code .= $tab2 . sprintf( 'return call_user_func_array(array( $%s, "%s"), $args);', $singletonName, $method) . $endl;
			$code .= $tab . '}'. $endl;
		}
		$code .="}\n";
		eval( $code );
		return $code;
	}
	
	
}
?>