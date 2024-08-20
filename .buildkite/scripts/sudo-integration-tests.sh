#!/usr/bin/env bash

# The script is used to run integration tests with sudo
source /opt/buildkite-agent/hooks/pre-command 
source .buildkite/hooks/pre-command || echo "No pre-command hook found"

GROUP_NAME=$1
TESTS_TO_RUN=$2

echo "~~~ Running integration tests as $USER"
echo "~~~ Integration tests: ${GROUP_NAME}"
# TODO: Pass the actual version of the agen
gotestsum --version
AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile "build/${GROUP_NAME}.integration.xml" --jsonfile "build/${GROUP_NAME}.integration.out.json" -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "${TESTS_TO_RUN}" github.com/elastic/elastic-agent/testing/integration


# echo "~~~ Integration tests: Default"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-default.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-default.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestAPMConfig|TestDiagnosticsOptionalValues|TestIsolatedUnitsDiagnosticsOptionalValues|TestDiagnosticsCommand|TestIsolatedUnitsDiagnosticsCommand|TestEventLogFile|TestFakeComponent|TestFakeIsolatedUnitsComponent|TestOtelFileProcessing|TestOtelLogsIngestion|TestOtelAPMIngestion|TestPackageVersion)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Upgrade"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-upgrade-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-upgrade-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestUpgradeBrokenPackageVersion|TestStandaloneUpgradeWithGPGFallback|TestStandaloneUpgradeWithGPGFallbackOneRemoteFailing|TestStandaloneUpgradeRollback|TestStandaloneUpgradeRollbackOnRestarts|TestStandaloneUpgradeFailsWhenUpgradeIsInProgress|TestStandaloneUpgradeRetryDownload|TestStandaloneUpgradeSameCommit|TestStandaloneUpgrade|TestStandaloneUpgradeUninstallKillWatcher)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Container"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-container-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-container-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestContainerCMD|TestContainerCMDWithAVeryLongStatePath|TestContainerCMDEventToStderr|TestEventLogOutputConfiguredViaFleet)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Fleet"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestLongRunningAgentForLeaks|TestDelayEnroll|TestDelayEnrollUnprivileged|TestInstallAndCLIUninstallWithEndpointSecurity|TestInstallAndUnenrollWithEndpointSecurity|TestInstallWithEndpointSecurityAndRemoveEndpointIntegration|TestEndpointSecurityNonDefaultBasePath|TestEndpointSecurityUnprivileged|TestEndpointSecurityCannotSwitchToUnprivileged|TestEndpointLogsAreCollectedInDiagnostics|TestForceInstallOverProtectedPolicy|TestSetLogLevelFleetManaged|TestLogIngestionFleetManaged|TestMetricsMonitoringCorrectBinaries|TestEndpointAgentServiceMonitoring|TestMonitoringPreserveTextConfig|TestMonitoringLivenessReloadable|TestComponentBuildHashInDiagnostics|TestProxyURL|TestFleetManagedUpgradeUnprivileged)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: FQDN"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fqdn-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fqdn-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestFQDN)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Deb"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-deb-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-deb-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestDebLogIngestFleetManaged|TestDebFleetUpgrade)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Fleet Airgapped"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-airgapped-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-airgapped-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestFleetAirGappedUpgradeUnprivileged)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Fleet Privileged"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-privileged-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-privileged-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestInstallFleetServerBootstrap|TestFleetManagedUpgradePrivileged)$" github.com/elastic/elastic-agent/testing/integration
# echo "~~~ Integration tests: Fleet Airgapped Privileged"
# AGENT_VERSION="8.16.0-SNAPSHOT" SNAPSHOT=true TEST_DEFINE_PREFIX=sudo_linux gotestsum --no-color -f standard-quiet --junitfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-airgapped-privileged-sudo.integration.xml --jsonfile build/TEST-go-remote-linux-amd64-ubuntu-2404-fleet-airgapped-privileged-sudo.integration.out.json -- -tags integration -test.shuffle on -test.timeout 2h0m0s -test.run "^(TestFleetAirGappedUpgradePrivileged)$" github.com/elastic/elastic-agent/testing/integration