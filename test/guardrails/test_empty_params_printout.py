import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.services import Services, Service
import yaml
import ruamel.yaml
import json
import os
from jinja2 import Template, Environment, FileSystemLoader

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class EmptyParamsPrintoutTestCase(unittest.TestCase):
    def test_empty_params_printout(self):
        services = Services(service_names=["Kubernetes"])
        display_names = services.display_names_params_required
        expected_keys = [
            "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits",
            "Kubernetes cluster containers should not share host process ID or host IPC namespace",
            "Kubernetes cluster containers should not use forbidden sysctl interfaces",
            "Kubernetes cluster containers should only listen on allowed ports",
            "Kubernetes cluster containers should only use allowed AppArmor profiles",
            "Kubernetes cluster containers should only use allowed ProcMountType",
            "Kubernetes cluster containers should only use allowed capabilities",
            "Kubernetes cluster containers should only use allowed images",
            "Kubernetes cluster containers should only use allowed seccomp profiles",
            "Kubernetes cluster containers should run with a read only root file system",
            "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers",
            "Kubernetes cluster pod hostPath volumes should only use allowed host paths",
            "Kubernetes cluster pods and containers should only run with approved user and group IDs",
            "Kubernetes cluster pods and containers should only use allowed SELinux options",
            "Kubernetes cluster pods should only use allowed volume types",
            "Kubernetes cluster pods should only use approved host network and port range",
            "Kubernetes cluster pods should use specified labels",
            "Kubernetes cluster services should listen only on allowed ports",
            "Kubernetes cluster should not allow privileged containers",
            "Kubernetes clusters should be accessible only over HTTPS",
            "Kubernetes clusters should not allow container privilege escalation",
            "Kubernetes clusters should use internal load balancers",
            "[Preview]: Kubernetes cluster services should only use allowed external IPs",
            "[Preview]: Kubernetes clusters should disable automounting API credentials",
            "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities",
            "[Preview]: Kubernetes clusters should not use specific security capabilities",
            "[Preview]: Kubernetes clusters should not use the default namespace"
        ]
        print(json.dumps(display_names, indent=4))
        self.maxDiff = None
        # Doing this in a loop to future-proof the unit test
        # self.assertListEqual(display_names, expected_keys)
        # print(ruamel.yaml.dump(display_names, Dumper=ruamel.yaml.RoundTripDumper))
        for expected_key in expected_keys:
            self.assertTrue(expected_key in display_names)

        policies = {"Kubernetes": display_names}
        header_format_string = """# ---------------------------------------------------------------------------------------------------------------------
# {{ service_name }}
# ---------------------------------------------------------------------------------------------------------------------

{{ content }}
"""
        header_template = Template(header_format_string)
        service_entries = []
        for service_name, service_policies in policies.items():
            pretty_policies = ruamel.yaml.dump(service_policies, Dumper=ruamel.yaml.RoundTripDumper)
            rendered = header_template.render(dict(service_name=service_name, content=pretty_policies))
            service_entries.append(rendered)
        template_contents = dict(
            service_entries=service_entries,
        )
        template_path = os.path.join(os.path.dirname(__file__))
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        template = env.get_template("service-parameters-template.yml")
        result = template.render(t=template_contents)
        print(result)
