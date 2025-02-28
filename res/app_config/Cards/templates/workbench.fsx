<template id="workbench">
  <Card elevation="1" color="#ffffff">
    <Padding padding="8.0,8.0,8.0,8.0">
      <Column mainAxisSize="min">
        // Title
        <Row crossAxisAlignment="center" mainAxisAlignment="spaceBetween" mainAxisSize="max">
            <Text textAlign="start" overflow="ellipsis" style:fontColor="ff448aff" style:fontSize="18.0"
                  value:binding="title" value="This is the title"/>
        </Row>
        // Subtitle
        <Text textAlign="start" value:binding="subtitle" value="This is the subtitle"/>
      </Column>
    </Padding>
  </Card>
</template>
  