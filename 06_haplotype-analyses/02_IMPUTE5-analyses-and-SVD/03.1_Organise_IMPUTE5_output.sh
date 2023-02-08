output_folder=./pop_structure/data/IMPUTE5_Output/60K_analyses

mkdir $output_folder/Tranche{1..4}

mv $output_folder/MT_MCPS_60K_hapcopy{1..4}*.shared.gz $output_folder/Tranche1
mv $output_folder/MT_MCPS_60K_hapcopy5p.shared.gz $output_folder/Tranche1
mv $output_folder/MT_MCPS_60K_hapcopy5q.shared.gz $output_folder/Tranche2
mv $output_folder/MT_MCPS_60K_hapcopy{6..9}*.shared.gz $output_folder/Tranche2
mv $output_folder/MT_MCPS_60K_hapcopy{10..13}*.shared.gz $output_folder/Tranche3
mv $output_folder/MT_MCPS_60K_hapcopy14p.shared.gz $output_folder/Tranche3
mv $output_folder/MT_MCPS_60K_hapcopy14q.shared.gz $output_folder/Tranche4
mv $output_folder/MT_MCPS_60K_hapcopy{15..22}*.shared.gz $output_folder/Tranche4
