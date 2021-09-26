from autopkglib import Processor, ProcessorError
import hashlib

__all__ = ["StringToInstalls"]

class StringToInstalls(Processor):
    input_variables = {
        "faux_root": {
            "required": True,
            "description": "Path where installs array files can be found"
        },
        "installs_string": {
            "required": True,
            "description": "String that will be converted to installs array"
        },
        "separator": {
            "required": False,
            "default": ",", 
            "description": "Character to split installs_string into installs array"
        }
    }

    output_variables = {}

    def main(self):
        if "installs_string" not in self.env:
            self.env["installs_string"] = ""
        if self.env["installs_string"] != "":
            if "pkginfo" not in self.env:
                self.env["pkginfo"] = {}
            if "installs" not in self.env["pkginfo"]: 
               self.env["pkginfo"]["installs"] = []

            arr = self.env["installs_string"].split(self.env["separator"])
            for item in arr:
                full_path = f"{self.env['faux_root']}/" + item
                try: 
                    with open(full_path, 'rb') as f:
                        checksum = hashlib.md5(f.read()).hexdigest()
                        self.env["pkginfo"]["installs"].append({
                            "path": "/" + item,
                            "md5checksum": checksum,
                            "type": "file"
                        })
                except IOError:
                    raise ProcessorError(
                        f"{full_path} could not be hashed because this file could not be found."
                    )
        self.output(f"self.env['pkginfo']['installs'] = {self.env['pkginfo']['installs']}")

if __name__ == "__main__":
    PROCESSOR = StringToInstalls()
    PROCESSOR.execute_shell()