#!/bin/bash

. 000_get_context.sh
. 001_initial_cluster_config.sh
. 002_install_istio_primary.sh
. 003_install_istio_secondary.sh
. 004_create_remote_secrets.sh
. 005_install_sample_app.sh
. 007_addons.sh


