from setuptools import find_packages, setup

setup_output = setup(
    name="custom_source_examples",
    version="1.0",
    description="Sample project for Datahub custom sources",
    package_dir={"": "src"},
    packages=find_packages("src"),
    install_requires=["acryl-datahub"],
)
