from typing import Iterable

from datahub.configuration.common import ConfigModel
from datahub.ingestion.api.common import PipelineContext
from datahub.ingestion.api.source import Source, SourceReport
from datahub.ingestion.api.workunit import MetadataWorkUnit
from datahub.metadata.com.linkedin.pegasus2avro.mxe import MetadataChangeEvent

import json
import os


class MyCustomSourceConfig(ConfigModel):
    env: str = "PROD"


class MyCustomSource(Source):
    source_config: MyCustomSourceConfig
    report: SourceReport = SourceReport()

    def __init__(self, config: MyCustomSourceConfig, ctx: PipelineContext):
        super().__init__(ctx)
        self.source_config = config

    @classmethod
    def create(cls, config_dict, ctx):
        config = MyCustomSourceConfig.parse_obj(config_dict)
        return cls(config, ctx)

    def get_workunits(self) -> Iterable[MetadataWorkUnit]:
        with open(
            os.path.join(os.path.dirname(__file__), "../example_mce/single_mce.json"),
            "r",
        ) as f:
            obj = json.load(f)
            item = MetadataChangeEvent.from_obj(obj)
            wu = MetadataWorkUnit("single_mce", mce=item)
            self.report.report_workunit(wu)
            yield wu

    def get_report(self) -> SourceReport:
        return self.report

    def close(self) -> None:
        pass
