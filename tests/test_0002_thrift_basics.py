from pbtests.packetbeat import TestCase


class Test(TestCase):

    def tutorial_asserts(self, objs):
        assert len(objs) == 17
        assert all([o["type"] == "thrift" for o in objs])
        assert all([o["thrift"]["request"]["size"] > 0 for o in objs])

        assert objs[0]["thrift"]["request"]["method"] == "ping"
        assert objs[0]["thrift"]["request"]["params"] == "()"
        assert objs[0]["thrift"]["reply"]["returnValue"] == ""

        assert objs[1]["thrift"]["request"]["method"] == "add"
        assert objs[1]["thrift"]["request"]["params"] == "(1: 1, 2: 1)"
        assert objs[1]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[2]["thrift"]["request"]["method"] == "add16"
        assert objs[2]["thrift"]["request"]["params"] == "(1: 1, 2: 1)"
        assert objs[2]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[3]["thrift"]["request"]["method"] == "add64"
        assert objs[3]["thrift"]["request"]["params"] == "(1: 1, 2: 1)"
        assert objs[3]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[4]["thrift"]["request"]["method"] == "add_doubles"
        assert objs[4]["thrift"]["request"]["params"] == "(1: 1.2, 2: 1.3)"
        assert objs[4]["thrift"]["reply"]["returnValue"] == "2.5"

        assert objs[5]["thrift"]["request"]["method"] == "echo_bool"
        assert objs[5]["thrift"]["request"]["params"] == "(1: true)"
        assert objs[5]["thrift"]["reply"]["returnValue"] == "true"

        assert objs[6]["thrift"]["request"]["method"] == "echo_string"
        assert objs[6]["thrift"]["request"]["params"] == "(1: \"hello\")"
        assert objs[6]["thrift"]["reply"]["returnValue"] == "\"hello\""

    def test_thrift_tutorial_socket(self):
        self.render_config_template(
            thrift_ports=[9090]
        )
        self.run_packetbeat(pcap="thrift_tutorial.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()

        self.tutorial_asserts(objs)

        # request_raw and response_raw are present by default
        assert all([len(o["request_raw"]) > 0 for o in objs])
        assert all(["response_raw" in o for o in objs])
        assert objs[0]["request_raw"] == "ping()"
        assert objs[11]["response_raw"] == "Exceptions: (1: (1: 4, 2: " + \
            "\"Cannot divide by 0\"))"
        assert all([o["dst_port"] == 9090 for o in objs])

    def test_thrift_tutorial_framed(self):
        self.render_config_template(
            thrift_ports=[9090],
            thrift_transport_type="framed"
        )
        self.run_packetbeat(pcap="thrift_tutorial_framed_transport.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()

        self.tutorial_asserts(objs)

    def test_thrift_tutorial_with_idl(self):
        self.render_config_template(
            thrift_ports=[9091],
            thrift_idl_files=["tutorial.thrift", "shared.thrift"]
        )
        self.copy_files(["tutorial.thrift", "shared.thrift"])
        self.run_packetbeat(pcap="thrift_tutorial.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()
        assert len(objs) == 17
        assert all([o["type"] == "thrift" for o in objs])
        assert all([o["thrift"]["service"] == "Calculator"])

        assert objs[0]["thrift"]["request"]["method"] == "ping"
        assert objs[0]["thrift"]["request"]["params"] == "()"
        assert objs[0]["thrift"]["reply"]["returnValue"] == ""

        assert objs[1]["thrift"]["request"]["method"] == "add"
        assert objs[1]["thrift"]["request"]["params"] == "(num1: 1, num2: 1)"
        assert objs[1]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[2]["thrift"]["request"]["method"] == "add16"
        assert objs[2]["thrift"]["request"]["params"] == "(num1: 1, num2: 1)"
        assert objs[2]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[3]["thrift"]["request"]["method"] == "add64"
        assert objs[3]["thrift"]["request"]["params"] == "(num1: 1, num2: 1)"
        assert objs[3]["thrift"]["reply"]["returnValue"] == "2"

        assert objs[4]["thrift"]["request"]["method"] == "add_doubles"
        assert objs[4]["thrift"]["request"]["params"] == \
            "(num1: 1.2, num2: 1.3)"
        assert objs[4]["thrift"]["reply"]["returnValue"] == "2.5"

        assert objs[5]["thrift"]["request"]["method"] == "echo_bool"
        assert objs[5]["thrift"]["request"]["params"] == "(b: true)"
        assert objs[5]["thrift"]["reply"]["returnValue"] == "true"

        assert objs[6]["thrift"]["request"]["method"] == "echo_string"
        assert objs[6]["thrift"]["request"]["params"] == "(s: \"hello\")"
        assert objs[6]["thrift"]["reply"]["returnValue"] == "\"hello\""

    def test_thrift_integration(self):
        """
        Test based on the integration test suite of the Thrift
        project. Pcap generated by running:

        py/TestServer.py --proto=binary --port=9090 \
            --genpydir=gen-py TSimpleServer
        py/TestClient.py --proto=binary --port=9090 \
            --host=localhost --genpydir=gen-py
        """

        self.render_config_template(
            thrift_ports=[9091],
            thrift_idl_files=["ThriftTest.thrift"]
        )

        self.copy_files(["ThriftTest.thrift"])
        self.run_packetbeat(pcap="thrift_integration.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()
        assert len(objs) == 25
        assert all([o["type"] == "thrift" for o in objs])
        assert all([o["thrift"]["service"] == "ThriftTest"])

        # check a few things

        assert objs[0]["thrift"]["request"]["method"] == "testByte"
        assert objs[0]["thrift"]["request"]["params"] == "(thing: 63)"
        assert objs[0]["thrift"]["reply"]["returnValue"] == "63"

        assert objs[5]["thrift"]["request"]["method"] == "testEnum"
        assert objs[5]["thrift"]["request"]["params"] == "(thing: 5)"
        assert objs[5]["thrift"]["reply"]["returnValue"] == "5"

        assert objs[17]["thrift"]["request"]["method"] == "testOneway"
        assert objs[17]["thrift"]["request"]["params"] == "(secondsToSleep: 1)"
        assert "reply" not in objs[17]["thrift"]

        assert objs[20]["thrift"]["request"]["method"] == "testString"
        assert objs[20]["thrift"]["request"]["params"] == "(thing: \"" + \
            ("Python" * 20) + "\")"
        assert objs[20]["thrift"]["reply"]["returnValue"] == '"' + \
            ("Python" * 20) + '"'

    def test_thrift_send_request_response(self):
        # send_request=true send_response=false
        self.render_config_template(
            thrift_ports=[9091],
            thrift_idl_files=["ThriftTest.thrift"],
            thrift_no_send_request=False,
            thrift_no_send_response=True,
        )
        self.copy_files(["ThriftTest.thrift"])
        self.run_packetbeat(pcap="thrift_integration.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()

        assert all([len(o["request_raw"]) > 0 for o in objs])
        assert all([o["response_raw"] == "" for o in objs])

        # send_request=false send_response=false
        self.render_config_template(
            thrift_ports=[9091],
            thrift_idl_files=["ThriftTest.thrift"],
            thrift_no_send_request=True,
            thrift_no_send_response=True,
        )
        self.copy_files(["ThriftTest.thrift"])
        self.run_packetbeat(pcap="thrift_integration.pcap",
                            debug_selectors=["thrift"])

        objs = self.read_output()

        assert all([o["request_raw"] == "" for o in objs])
        assert all([o["response_raw"] == "" for o in objs])
