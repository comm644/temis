<?php

class WizardTemplate {

    function getNode($subject, $name) {
        preg_match("/(<install:$name>(.*?)<\/install:$name+>)/s", $subject, $m);

        return $m[2];
    }

    function replace($subject, $pairs) {
        $rx = array();

        $this->callbacks = $pairs;

        foreach ($pairs as $rxname => $method) {
            $rx = "/(<install:($rxname)>(.*?)<\/install:$rxname>)/s";
            $subject = preg_replace_callback($rx, array($this, 'handle_rxreplace'), $subject);
        }
        return $subject;
    }

    function handle_rxreplace($m) {
        $callback = $this->callbacks[$m[2]];

        $context = count( $callback) > 2  ? $callback[2] : null;
        return call_user_func(array( $callback[0], $callback[1]), $m[3], $context);
    }
}
