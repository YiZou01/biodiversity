system_prompt <- paste('
Classify the abstract using only the abstract text.

Output JSON with exactly two keys: fieldwork and primary_data.
Allowed values for both keys: Yes, No, Unclear.

Definitions:

1) fieldwork
Fieldwork asks about the study setting.
- Yes = the abstract clearly describes field-based sampling, observation, survey, monitoring, or manipulation conducted in natural or semi-natural outdoor settings.
- No = the study is only lab, greenhouse, growth chamber, common garden, aquarium, mesocosm, model, simulation, theory, review, meta-analysis, database, GIS, remote sensing only, museum/herbarium, archive, historical record, or previously published data, with no clear field component.
- Unclear = the abstract does not provide enough information to tell whether actual field-based work occurred.

2) primary_data
Primary_data asks whether the study analyzes data generated for this study.
- Yes = the abstract indicates that this study generated or collected its own data, including sampling, measuring, surveying, trapping, recording, monitoring, interviewing, experimenting, sequencing, or otherwise producing study-specific observations or measurements. This includes cases where the abstract reports study-specific sites, plots, transects, specimens, individuals, dates, treatments, or sample sizes, unless it clearly says those data came only from pre-existing sources.
- No = the study uses only existing literature, published studies, databases, archives, museum/herbarium collections, historical records, remote sensing products, or other pre-existing data.
- Unclear = the abstract is too vague to determine whether the reported data were newly generated for this study or came only from pre-existing sources.

Important rules:
- Use only the abstract.
- Do not invent methods or evidence not stated in the abstract.
- However, use the most natural reading of concrete study descriptions. Do not require the exact words “we collected” or “we generated” if the abstract clearly describes this study’s own samples, measurements, experiments, surveys, or observations.
- Prefer Yes or No when the abstract gives reasonably direct evidence. Use Unclear only when the source of the data or the study setting truly cannot be determined.
- fieldwork and primary_data are independent:
  - lab experiment can be fieldwork = No and primary_data = Yes
  - field survey can be fieldwork = Yes and primary_data = Yes
  - review/meta-analysis can be fieldwork = No and primary_data = No
  - remote sensing only using existing products is fieldwork = No and primary_data = No
- If authors used existing data and also collected/generated their own data, primary_data = Yes.

Examples of strong cues for primary_data = Yes:
“we sampled”, “we measured”, “we surveyed”, “we recorded”, “we monitored”, “we trapped”, “we quantified”, “we sequenced”, “in X plots/sites”, “from X individuals/specimens”, “across X streams/forests/grasslands”, “experimental treatments”, “field experiment”, “we compared plots”, “we collected soil/water/leaf samples”.

Examples of strong cues for primary_data = No:
“review”, “meta-analysis”, “using published studies”, “from the literature”, “database”, “archival records”, “museum collection”, “herbarium records”, “historical records”, “satellite products”, “remote sensing products”, “secondary data only”.

Output only JSON in this exact format:{"fieldwork":"Yes","primary_data":"No"}'
)