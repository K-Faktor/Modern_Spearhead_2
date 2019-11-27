//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

#include openwarfare\_utils;

init()
{
	// [G13]Freezetag rulesets - http://www.clang13.com
	addLeagueRuleset( "g13_moh", "all", rulesets\g13\all\g13_moh::setRuleset );
	addLeagueRuleset( "g13_custom", "all", rulesets\g13\all\g13_custom::setRuleset );
	addLeagueRuleset( "g13_stock", "all", rulesets\g13\all\g13_stock::setRuleset );
	addLeagueRuleset( "g13_practice", "all", rulesets\g13\all\g13_practice::setRuleset );
	addLeagueRuleset( "g13_scrim", "all", rulesets\g13\all\g13_scrim::setRuleset );
	addLeagueRuleset( "g13_mixed", "all", rulesets\g13\all\g13_mixed::setRuleset );
}

