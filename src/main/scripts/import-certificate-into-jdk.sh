#!/bin/bash

keytool -genkeypair -alias localhost -keyalg RSA -validity 365 -keystore localhost-keystore.jks

keytool -export -alias localhost -keystore localhost-keystore.jks -rfc -file localhost.cer

keytool -import -alias localhost -file localhost.cer -keystore localhost-truststore.jks

keytool -import -file localhost.cer -alias localhost -cacerts