#!/usr/bin/env bash

# Step1: Run bcftools isec to compare twist dilution series to expected variant calls

#--- 1. bcftools ---#
regions_bed="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_horizon/ctTSO_horizon/TST500C_manifest_merged_hg19.bed"
nameRef1="TwistReference-SNVs" # include version
vcfRef1="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/Twist_cfDNA_Pan-cancer_Reference_SNV_variant_sites_hg19_version_1a.vcf_sorted.vcf.gz"
nameRef2="TwistReference-Indels" # include version
vcfRef2="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/Twist_cfDNA_Pan-cancer_Reference_indel_variant_sites_hg19_version_1a.vcf_sorted.vcf.gz"
lab1="unfiltered" #ie "Dragen-3-9-3"
lab2="PassOnly"
name1="Twist0pc"
vcf1="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/vcf_files/data/PTC_TwistVAF0pc_L2201383_MergedSmallVariants.vcf.gz"

outdir1="results/$name1_$lab1_$nameRef1"
outdir2="results/$name1_$lab1_$nameRef2"
outdir3="results/$name1_$lab2_$nameRef1"
outdir4="results/$name1_$lab2_$nameRef2"



bcftools isec $vcf1 $vcfRef1 -p $outdir1 -R $regions_bed
bcftools isec $vcf1 $vcfRef2 -p $outdir2 -R $regions_bed
bcftools isec $vcf1 $vcfRef1 -p $outdir3 -R $regions_bed -f .,PASS
bcftools isec $vcf1 $vcfRef2 -p $outdir4 -R $regions_bed -f .,PASS
