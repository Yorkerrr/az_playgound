#!/bin/bash

bash 000_get_context.sh
bash 001_initial_cluster_config.sh
bash 002_install_istio_primary.sh
bash 003_install_istio_secondary.sh
bash 004_update_coredns.sh
bash 005_install_sample_app.sh
bash 006_fix_filter.sh
bash 007_addons.sh


