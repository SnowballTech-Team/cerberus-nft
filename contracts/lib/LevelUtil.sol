//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

library LevelUtil {
    enum Level {
        Soldier,
        General,
        Chieftain,
        King,
        Astronaut,
        Alien,
        Martian,
        Collector
    }

    /**
     * Doge Soldier 1-1,000 ,1k-10k
     * Doge General 1,001-2,000 ,10k-20k
     * Doge Chieftain 2,001-10,000 ,20k-100k
     * Doge King 10,001-50,000 ,100k-500k
     * Doge Astronaut 50,001-100,000 ,500k-1M
     * Doge Alien 100,001-200,000, 1M-2M
     * Doge Martian 200,001-1,000,000 ,2M-10M
     * Doge Collector 1,000,001+ ,10M+
     */
    function checkLevel(uint256 _cdoge, uint256 _berus)
        internal
        pure
        returns (Level lv)
    {
        // Soldier 1-1,000 ,1k-10k
        if (_cdoge < 1001 && _berus < 10000) {
            return Level.Soldier;
        }
        // General 1,001-2,000 ,10k-20k
        if (_cdoge < 2001 && _berus < 20000) {
            return Level.General;
        }
        // Chieftain 2,001-10,000 ,20k-100k
        if (_cdoge < 10000 && _berus < 100000) {
            return Level.Chieftain;
        }
        // King 10,001-50,000 ,100k-500k
        if (_cdoge < 50001 && _berus < 500000) {
            return Level.King;
        }
        // Astronaut 50,001-100,000 ,500k-1M
        if (_cdoge < 100001 && _berus < 1000000) {
            return Level.Astronaut;
        }
        // Alien 100,001-200,000, 1M-2M
        if (_cdoge < 200001 && _berus < 2000000) {
            return Level.Alien;
        }
        // Martian 200,001-1,000,000 ,2M-10M
        if (_cdoge < 1000001 && _berus < 10000000) {
            return Level.Martian;
        }
        //  Collector 1,000,001+ ,10M+
        if (_cdoge > 1000000 && _berus > 10000000) {
            return Level.Collector;
        }
    }

    /**
     * Doge Soldier 1%
     * Doge General 2%
     * Doge Chieftain 3%
     * Doge King 6.9%
     * Doge Astronaut 8%
     * Doge Alien 9%
     * Doge Martian 10%
     * Doge Collector 16.9%
     */
    function checkBonus(Level lv) internal pure returns (uint256 bonus) {
        if (lv == Level.Soldier) {
            return 100;
        }
        if (lv == Level.General) {
            return 200;
        }
        if (lv == Level.Chieftain) {
            return 300;
        }
        if (lv == Level.King) {
            return 690;
        }
        if (lv == Level.Astronaut) {
            return 800;
        }
        if (lv == Level.Alien) {
            return 900;
        }
        if (lv == Level.Martian) {
            return 1000;
        }
        if (lv == Level.Collector) {
            return 1690;
        }
    }
}
